// 회원 탈퇴: 요청한 사용자 본인의 Storage 파일과 Auth 계정을 삭제한다.
// public.users 이하 데이터는 FK(on delete cascade)로 함께 삭제되며,
// 결제 기록(payments)은 법정 보관을 위해 user_id만 NULL로 남는다.
import { createClient } from 'npm:@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

const PAGE_SIZE = 1000;

type AdminClient = ReturnType<typeof createClient>;

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}

/** prefix 폴더 아래의 모든 파일 경로를 재귀적으로 수집한다. */
async function listFilesRecursive(
  client: AdminClient,
  bucket: string,
  prefix: string,
): Promise<string[]> {
  const files: string[] = [];
  const folders = [prefix];

  while (folders.length > 0) {
    const folder = folders.pop()!;
    for (let offset = 0; ; offset += PAGE_SIZE) {
      const { data, error } = await client.storage
        .from(bucket)
        .list(folder, { limit: PAGE_SIZE, offset });
      if (error) throw error;

      for (const item of data) {
        const path = `${folder}/${item.name}`;
        // 폴더 항목은 id가 null이다
        if (item.id === null) {
          folders.push(path);
        } else {
          files.push(path);
        }
      }
      if (data.length < PAGE_SIZE) break;
    }
  }
  return files;
}

async function removeFolders(client: AdminClient, bucket: string, prefixes: string[]) {
  for (const prefix of prefixes) {
    const files = await listFilesRecursive(client, bucket, prefix);
    for (let i = 0; i < files.length; i += PAGE_SIZE) {
      const { error } = await client.storage.from(bucket).remove(files.slice(i, i + PAGE_SIZE));
      if (error) throw error;
    }
  }
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }
  if (req.method !== 'POST') {
    return json({ error: 'METHOD_NOT_ALLOWED' }, 405);
  }

  const token = req.headers.get('Authorization')?.replace(/^Bearer\s+/i, '');
  if (!token) {
    return json({ error: 'AUTH_REQUIRED' }, 401);
  }

  const admin = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    { auth: { persistSession: false, autoRefreshToken: false } },
  );

  const { data: userData, error: userError } = await admin.auth.getUser(token);
  if (userError || !userData.user) {
    return json({ error: 'AUTH_REQUIRED' }, 401);
  }
  const userId = userData.user.id;

  try {
    const { data: dogs, error: dogsError } = await admin
      .from('dogs')
      .select('id')
      .eq('owner_id', userId);
    if (dogsError) throw dogsError;
    const dogIds = (dogs ?? []).map((dog: { id: string }) => dog.id);

    await removeFolders(admin, 'dog-profiles', [userId]);
    for (const bucket of ['exercise-videos', 'pose-data', 'analysis-reports']) {
      await removeFolders(admin, bucket, dogIds);
    }

    const { error: deleteError } = await admin.auth.admin.deleteUser(userId);
    if (deleteError) throw deleteError;

    return json({ ok: true });
  } catch (error) {
    console.error('delete-account failed', error);
    return json({ error: 'DELETE_FAILED' }, 500);
  }
});
