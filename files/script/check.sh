: ${SOURCE_METHOD? "Por favor, informe se será GIT ou VOLUME"}
: ${PROJECT_TYPE? "You need to informe which type project is this. JAVA, NODE, PHP"}

if ! [[ "${PROJECT_TYPE}" =~ ^(JAVA|NODE|PHP)$ ]]; then
  echo 'O projeto deve ser JAVA, NODE, PHP';
  exit 0;
fi