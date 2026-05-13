; Select a fenced code block including the fences
((fenced_code_block) @codeblock.outer)

; Select only the inside of the fenced code block
((fenced_code_block
  (code_fence_content) @codeblock.inner))

