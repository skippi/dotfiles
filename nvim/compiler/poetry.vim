if empty($POETRY_PATH)
  let $POETRY_PATH = "poetry"
endif

CompilerSet errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
CompilerSet makeprg=$POETRY_PATH
