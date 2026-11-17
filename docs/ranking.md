# 랭킹·배지 규격

보호자가 반려견의 운동을 자랑하고 서로 겨룰 수 있게 하는 월간 랭킹, 배지, 명예의 전당의 규칙입니다.
DB는 [20261116000100_ranking_and_badges.sql](../supabase/migrations/20261116000100_ranking_and_badges.sql),
앱은 `lib/features/ranking/`이 이 규칙을 그대로 따릅니다. 규칙을 바꾸면 이 문서, DB 함수, 앱의 점수 규칙 안내
(`showScoreRulesSheet`)를 함께 고칩니다.

## 원칙

- **많이보다 꾸준히.** 직원이 없는 무인 매장에서 무리한 운동을 부추기지 않도록 하루 1회만 점수를 주고, 한 번에 받을 수 있는 거리 점수에 상한을 둡니다. 최고 속도는 점수에도 순위에도 쓰지 않습니다.
- **중단해도 감점이 없습니다.** 비상정지를 망설이지 않게 하려는 것입니다.
- **점수는 트레드밀 기기 기록으로만 쌓입니다.** 운동 세션은 기기(관리자 계정)만 쓰고, 점수 원장은 DB 트리거만 씁니다. 보호자는 점수를 쓸 수 없습니다.
- **공개는 동의한 회원만, 닉네임으로 합니다.** 실명·이메일·연락처는 어떤 랭킹 응답에도 들어가지 않습니다.

## 점수 규칙 (scoring_version 1)

운동 세션이 `completed` 또는 `stopped`가 되는 순간 트리거(`exercise_sessions_award_points`)가 `exercise_points`에 한 번 적립합니다.

| 항목 | 점수 | 조건 |
|---|---|---|
| 출석 | 10 | 5분(300초) 이상 운동 |
| 달성 | 0~10 | `floor(10 × 운동 시간 ÷ 목표 시간)`, 최대 10. 목표 시간이 없으면 30분 기준 |
| 거리 | 0~20 | 100m당 1점, 최대 20 (2km 이상은 20) |
| 주간 보너스 | 20 | 한 주(월~일)에 점수를 받은 운동이 2회가 되면 한 번 |

- **5분 미만** 운동은 0점이고 운동 횟수·배지 집계에서도 빠집니다 (`note = 'too_short'`).
- **하루 1회**: 반려견마다 한국 시간 하루에 처음 점수를 받은 운동만 점수를 받습니다. 두 번째부터는 0점(`note = 'daily_limit'`)이지만 운동 횟수·배지에는 들어갑니다.
- **중단된 운동**은 감점 없이 한 만큼 받습니다 (예: 30분 프로그램에서 15분·900m에 멈추면 10 + 5 + 9 = 24점).
- **주간 보너스**는 그 주 두 번째로 점수를 받은 운동에 붙고, 그 운동의 달 점수가 됩니다. 운동 기록 화면에서는 그 운동 점수에 합쳐 보여 줍니다.
- **기간**은 모두 한국 시간(Asia/Seoul)입니다. 운동일은 시작 시각 기준이라, 말일 23:50에 시작한 운동은 그 달 점수입니다.
- **무효 처리**: 운영자가 `void_exercise_points(session_id, reason)`으로 부정 기록을 무효로 하면 순위·배지 집계에서 빠지고, 그 주의 점수 받은 운동이 2회 미만이 되면 주간 보너스도 무효가 됩니다. 이미 준 배지는 회수하지 않습니다.
- 점수 공식을 바꿀 때는 `scoring_version`을 올리고, 이미 쌓인 점수는 다시 계산하지 않습니다.

## 월간 랭킹

| 범위 | `scope` / `scope_key` | 순위 기준 |
|---|---|---|
| 전체 | `all` / `all` | 이번 달 전체 점수 |
| 지점 | `branch` / 지점 ID | 그 지점에서 받은 점수만 |
| 체급 | `size` / `small`·`medium`·`large` | 같은 체구(`dogs.size_class`)끼리 전체 점수. 체구가 없으면 빠짐 |

- **참여 대상**: 보호자의 최신 랭킹 동의(`data_consents`의 `ranking`)가 `granted`이고 삭제되지 않은 반려견 중 그 달 점수가 0보다 큰 반려견.
- **동점**이면 그 점수에 먼저 도달한(마지막으로 점수를 받은 시각이 이른) 반려견이 위입니다.
- **공개 항목**: 순위, 반려견 이름·견종·체구, 프로필 사진(보호자가 사진 공개를 켰을 때만), 닉네임, 이번 달 주 지점, 점수·운동 횟수·거리, 응원 수, 지난달 칭호(1~3위).
- **내 순위**(`get_my_ranking`)는 참여하지 않았어도 계산합니다. 이때 내 반려견만 함께 넣어 "참여하면 n위"로 보여 주고, 다른 회원에게는 노출하지 않습니다.
- **지점 대항전**(`get_branch_battle`)은 지점별로 모든 회원의 운동 거리를 합산합니다. 개인을 드러내지 않는 합계라 동의와 무관하게 셉니다.

## 닉네임

| 규칙 | 값 |
|---|---|
| 형식 | 2~12자, 완성형 한글·영문·숫자·밑줄(`_`) (DB 제약 `users_nickname_format`) |
| 고유 | 대소문자 구분 없이 고유 (`users_nickname_key`) |
| 기본값 | 가입 시 자동 생성 (예: "씩씩한발바닥0427"). 가입할 때 앱 언어가 영어(메타데이터 `locale` = `en`)면 영어 닉네임 (예: "SwiftPaw042", `private.generate_nickname_en`). 자동 닉네임은 바로 바꿀 수 있음 |
| 변경 주기 | 보호자가 바꾼 뒤 30일 (`private.nickname_change_interval()`) |
| 금칙어 | 사칭(관리자·운영자·PawFit 등)과 욕설 (`private.is_forbidden_nickname`) |
| 변경 방법 | `set_nickname(p_nickname)` RPC만. `users.nickname`을 직접 수정할 수 없음 |

## 랭킹 사진 공개

`dog-profiles` 버킷은 본인 폴더만 읽을 수 있지만, 아래를 모두 만족하는 사진은 로그인한 다른 회원도 서명 URL을 받을 수 있습니다 (Storage 정책 `dog_profiles_select_ranking`).

- 반려견의 **현재** 프로필 사진 경로(`dogs.profile_image_path`)와 같은 파일 (이전 사진은 공개되지 않음)
- 반려견이 삭제되지 않음
- 보호자가 랭킹에 참여 중이고 `users.ranking_show_photo = true`

## 배지

| 코드 | 이름 | 받는 조건 | 등급 |
|---|---|---|---|
| `first_run` | 첫 발걸음 | 운동 1회 | 동 |
| `sessions_10` | 열 번째 운동 | 운동 10회 | 동 |
| `sessions_30` | 단골 러너 | 운동 30회 | 은 |
| `sessions_100` | 백 번의 질주 | 운동 100회 | 금 |
| `distance_10k` | 10km 돌파 | 누적 10km | 동 |
| `marathon` | 마라톤 완주 | 누적 42.195km | 은 |
| `distance_100k` | 100km 클럽 | 누적 100km | 금 |
| `streak_4` | 4주 연속 출석 | 최장 연속 운동 주 4주 | 은 |
| `streak_12` | 12주 연속 출석 | 최장 연속 운동 주 12주 | 금 |
| `stamp_tour` | 스탬프 투어 | 서로 다른 지점 3곳 | 은 |
| `open_run` | 오픈런 | 지점 개점 후 30분 안에 시작한 운동 3회 (24시간 지점 제외) | 동 |
| `podium` | 시상대 | 월간 마감에서 어느 부문이든 1~3위 | 금 |

- 지표는 무효 처리되지 않은 5분 이상 운동으로 셉니다 (`private.dog_badge_stats`). 하루 1회 제한과 무관합니다.
- 연속 운동 주는 한 주(월~일)에 1회 이상 운동한 주가 이어진 수입니다. 화면의 "연속 운동"은 이번 주나 지난주까지 이어진 현재 기록이고, 배지는 최장 기록으로 판단합니다.
- 배지는 운동이 끝날 때 트리거가, 시상대는 월간 마감 때 지급합니다. 카탈로그(`badges`)는 관리자가 수정할 수 있고, 내릴 때는 `is_active = false`로 둡니다.

## 월간 마감 · 명예의 전당

- pg_cron 작업 `pawfit-close-ranking-months`가 매일 00:10(한국 시간, UTC 15:10)에 `private.close_due_ranking_months()`를 실행해, 점수가 있는데 마감하지 않은 지난 달을 모두 마감합니다.
- 마감(`private.close_ranking_month`)은 전체·체급 3개·점수가 있던 지점별로 1~3위(동점이면 함께)를 `monthly_awards`에 기록하고, `ranking_closings`에 마감 시각을 남깁니다. 같은 달은 다시 마감하지 않습니다.
- 수상 반려견은 「시상대」 배지를 받고, 보호자에게 받은 순위를 모은 알림이 한 번 갑니다 (예: "콩이가 10월 랭킹 전체 1위 · 용산 아이파크몰점 1위에 올랐어요.").
- 마감 시점에 랭킹에 참여한 반려견만 수상합니다. 이후 참여를 철회하거나 반려견을 삭제하면 명예의 전당(`get_hall_of_fame`)에서 "비공개 반려견"으로 가립니다.
- 다음 달 순위표에서는 지난달 1~3위에게 칭호(예: "10월 용산점 1위")가 붙습니다.
- cron이 멈췄을 때는 관리자가 `close_ranking_month(p_month)`로 수동 마감합니다. 진행 중인 달은 마감할 수 없습니다.

## 응원

- 랭킹에 참여한 다른 회원의 반려견을 한 달에 한 번 응원할 수 있습니다. 내 반려견은 응원할 수 없습니다.
- 응원을 받으면 보호자에게 알림이 갑니다. 응원한 사람이 랭킹 참여 중이면 닉네임을, 아니면 "다른 보호자"로 보여 줍니다.
- 누가 응원했는지 목록은 공개하지 않고 응원 수만 보여 줍니다.

## 알림 (`type = 'ranking'`)

| 상황 | 제목 | 본문 | 데이터 · 앱 이동 |
|---|---|---|---|
| 배지 획득 | 새 배지를 받았어요 | {반려견}의 「{배지}」 배지가 도착했어요. 배지함에서 확인해 보세요. | `dog_id`, `badge_code` → 배지함 |
| 응원 받음 | 응원이 도착했어요 | {닉네임}님이 {반려견}을 응원했어요. | `dog_id` → 랭킹 |
| 월간 수상 | {M}월 랭킹 시상대에 올랐어요 | {반려견}가 {M}월 랭킹 {부문 순위들}에 올랐어요. 명예의 전당에서 확인해 보세요. | `period_month`, `dog_id` → 명예의 전당 |

- 모든 알림의 `data`에는 앱이 현재 언어로 문구를 만들 수 있게 `msg`(문구 종류)와 `args`(값)도 들어갑니다 ([docs/i18n.md](i18n.md) "알림").
  - 배지 획득: `msg` = `badge_earned`, `args` = `dog_name`, `badge_code`, `badge_name`, `badge_name_en`
  - 응원 받음: `msg` = `cheer_received`, `args` = `dog_name`, `nickname` (응원한 사람이 랭킹에 참여하지 않으면 null)
  - 월간 수상: `msg` = `monthly_award`, `args` = `dog_name`, `month`(1~12), `awards` = `[{scope, label, label_en, rank}]` (본문의 부문 순서와 같다)
  - 운동 완료: `msg` = `exercise_completed`, `args` = `dog_name`, `points` (점수를 받지 못했으면 0)
- 알림 설정의 "랭킹 알림"(`notification_prefs.ranking`, 기본 켬)을 끄면 서버가 위 알림을 만들지 않습니다.
- 운동 완료 알림(`exercise`)에는 받은 점수를 함께 알려 줍니다 ("…운동이 끝났어요. 40점을 받았어요!"). 점수 트리거가 이름 순서상 완료 알림 트리거보다 먼저 실행되는 것에 기대므로 트리거 이름을 바꿀 때 주의합니다.

## DB 객체

| 테이블 | 용도 | 보호자 권한 |
|---|---|---|
| `exercise_points` | 점수 원장. 운동 1회(`session`)·주간 보너스(`weekly_bonus`) | 본인 것 조회 |
| `badges` | 배지 카탈로그 | 조회 |
| `dog_badges` | 반려견이 받은 배지 | 본인 반려견 것 조회 |
| `ranking_cheers` | 응원 (월·반려견·응원한 사람) | 본인이 한 응원 조회 |
| `monthly_awards` | 월간 1~3위 기록 | 본인 것 조회 |
| `ranking_closings` | 마감한 달 | 없음 (관리자) |
| `users.nickname`, `nickname_updated_at`, `ranking_show_photo` | 닉네임·사진 공개 설정 | 사진 공개만 직접 수정 |

| RPC | 호출 | 설명 |
|---|---|---|
| `get_leaderboard(p_month, p_scope, p_scope_key, p_limit)` | 로그인 회원 | 순위표 (최대 100) |
| `get_my_ranking(p_dog_id, p_month)` | 반려견 보호자 | 내 점수·범위별 순위·다음 순위까지 점수 (jsonb) |
| `get_branch_battle(p_month)` | 로그인 회원 | 지점 대항전 |
| `get_hall_of_fame(p_months)` | 로그인 회원 | 마감한 최근 달의 1~3위 (최대 24개월) |
| `get_ranking_dog_profile(p_dog_id, p_month)` | 로그인 회원 | 공개 프로필·배지·수상·응원 (참여 반려견 또는 내 반려견) |
| `get_dog_achievements(p_dog_id)` | 반려견 보호자 | 배지·진행률 지표·수상 기록 |
| `cheer_dog(p_dog_id)` | 로그인 회원 | 응원, 이번 달 응원 수 반환 |
| `set_nickname(p_nickname)` | 본인 | 닉네임 변경 |
| `void_exercise_points(p_session_id, p_reason)` | 관리자 | 점수 무효 처리 |
| `close_ranking_month(p_month)` | 관리자 | 수동 마감 |

`p_month`는 그 달의 아무 날짜(앱은 1일)를 받고, 비우면 한국 시간 기준 이번 달입니다.

### 영어 필드 (다국어)

RPC는 표시용 문구 필드마다 **같은 이름 + `_en`** 필드를 함께 돌려줍니다
([20261117000100_english_content.sql](../supabase/migrations/20261117000100_english_content.sql), [docs/i18n.md](i18n.md)).
영어 값이 없으면(예: 영어 이름을 넣지 않은 지점) `_en`에도 한국어 값이 들어갑니다.

| RPC | 영어 필드 |
|---|---|
| `get_leaderboard` | `breed_label_en`, `main_branch_name_en`, `title_label_en` |
| `get_my_ranking` | `ranks[].label_en` |
| `get_branch_battle` | `branch_name_en` |
| `get_ranking_dog_profile` | `breed_label_en`, `awards[].scope_label_en` |
| `get_dog_achievements` | `awards[].scope_label_en` |
| `get_hall_of_fame` | `scope_label_en`, `breed_label_en` |

- 범위 이름: 전체 `Overall`, 체급 `Small dogs`·`Medium dogs`·`Large dogs`, 지점은 `branches.name_en` (`private.ranking_scope_label_en`)
- 견종: 카탈로그 견종은 `breeds.name_en`, 믹스견은 `Mixed breed` / `Mixed (Maltese)`. 보호자가 적은 견종이 카탈로그에 없으면 입력한 그대로 (`private.dog_breed_label_en`)
- 배지 목록(`badges`)은 지금처럼 `code`·`earned_at`만 돌려주며, 앱은 배지 이름·설명을 `badges` 테이블의 `name`·`name_en`·`description`·`description_en`에서 읽습니다.

## 운영 메모

- 이 마이그레이션은 `20261113000100_dog_ai_profile.sql`(체구 `dogs.size_class`, 믹스견 `is_mixed`)이 먼저 적용되어 있어야 합니다. 원격에는 `npx supabase db push`로 둘을 함께 적용합니다.
- 원격 프로젝트에 pg_cron 확장이 켜집니다 (마이그레이션이 `create extension pg_cron`과 작업 등록을 함께 함). 작업 상태는 `select * from cron.job_run_details order by start_time desc`로 확인합니다.
- 트레드밀 기기 연동 전에는 운동 세션이 없어 점수도 쌓이지 않습니다. 로컬에서는 `seed.sql`의 샘플 계정(`sample1@pawfit.local` ~ `sample6@pawfit.local`, 비밀번호 `pawfit1234`)으로 랭킹 화면을 확인할 수 있습니다. 샘플은 원격에 적용되지 않습니다.
- 매장 랭킹 보드(`/board/{지점 ID}`)는 태블릿·TV를 지점 관리자(기기) 계정으로 로그인해 띄웁니다. 1분마다 새로 불러오며, 화면 꺼짐은 기기 설정에서 끕니다. 앱에서는 관리자 계정의 랭킹 화면 메뉴에서 열 수 있습니다.

## 정해지지 않은 것

| 항목 | 현재 | 결정할 것 |
|---|---|---|
| 수상 보상 | 배지·칭호·명예의 전당만 | 이용권 등 경품을 줄지 (주면 약관에 시상 규정 필요, 운영자 대시보드의 이용권 발급 기능 필요) |
| 금칙어 목록 | DB 함수에 기본 목록 | 운영하며 추가할 방식 (지금은 마이그레이션으로 함수 수정) |
| 부정 기록 기준 | 운영자 판단으로 무효 처리 | 원격 체크인·기기 오류 기록을 어떻게 판별할지 |
