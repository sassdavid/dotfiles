#!/usr/bin/env bash
# Claude Code subagent status line - replaces the default
# `name · description · token count` row for each visible subagent.
set -o pipefail

jq -c '
  def paint($n; $s): "\u001b[" + $n + "m" + $s + "\u001b[0m";
  def clip($n): if length > $n then .[0:$n - 1] + "…" else . end;

  def icon:
    if   . == "completed" then ["32", "✓"]
    elif . == "failed"    then ["31", "✗"]
    elif . == "running"   then ["33", "●"]
    else ["2", "◦"] end;

  # startTime format is undocumented, so accept ISO, epoch seconds and epoch ms.
  def elapsed:
    (if type == "string" then (fromdateiso8601? // null)
     elif type == "number" then (if . > 1e11 then . / 1000 else . end)
     else null end) as $t
    | if $t == null then null else (now - $t | floor) end
    | if . == null or . < 0 then null
      elif . < 60 then "\(.)s"
      elif . < 3600 then "\(. / 60 | floor)m\(. % 60)s"
      else "\(. / 3600 | floor)h\(. % 3600 / 60 | floor)m" end;

  def ctx($used; $size):
    if ($size // 0) <= 0 then null
    else (($used // 0) * 100 / $size | floor)
         | [(if . >= 90 then "31" elif . >= 70 then "33" else "32" end), "\(.)%"] end;

  def tokens: if (. // 0) < 1000 then null else ["2", "\(. / 1000 | floor)k"] end;

  # Profile ARNs keep only the id; Bedrock IDs drop routing prefix and suffixes.
  def model:
    split("/") | last
    | sub("\\[1m\\]$"; "") | sub("-v1:0$"; "")
    | sub("^(global|us|eu|apac|us-gov)\\.anthropic\\."; "") | sub("^anthropic\\."; "")
    | sub("^claude-"; "");

  (.columns // 80) as $cols
  | .tasks // []
  | .[]
  | . as $t
  | [ ($t.status // "" | icon),
      ["1", ($t.name // "task")],
      (($t.startTime | elapsed) as $e | if $e then ["2", $e] else empty end),
      (ctx($t.tokenCount; $t.contextWindowSize) // ($t.tokenCount | tokens) // empty),
      (if $t.effort then ["2", "·\($t.effort)"] else empty end),
      (if $t.model then ["2", ($t.model | model)] else empty end)
    ] as $seg
  # Description gets whatever width the fixed segments leave.
  | ($seg | map(.[1] | length) | add + length) as $used
  | ($cols - $used - 1) as $room
  | ($seg + (($t.description // "")
             | if . != "" and $room > 4 then [["2", clip($room)]] else [] end))
  | { id: $t.id, content: (map(paint(.[0]; .[1])) | join(" ")) }
'
