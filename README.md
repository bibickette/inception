# Inception
si probleme douverture a cause du kvm:
    sudo rmmod kvm_amd       
    sudo rmmod kvm

# dockerignore
Le fichier .dockerignore fonctionne un peu comme un .gitignore, mais pour Docker. Il sert à indiquer quels fichiers ou dossiers ne doivent pas être copiés dans l'image Docker quand tu construis ton image avec docker build.
🧠 Pourquoi l'utiliser ?

Quand tu fais un build Docker, tout ce qui est dans ton dossier (le build context) est envoyé au daemon Docker.
Si tu as des fichiers inutiles ou volumineux (logs, .git, node_modules...), tu ralentis ton build, alourdis ton image, et exposes potentiellement des secrets.


Voici un fichier .dockerignore typique :

.git/
.gitignore
node_modules/
*.log
*.env
__pycache__/
Dockerfile~

Cela évite de copier :

    le dossier .git (inutile dans l'image)

    des fichiers de config inutiles

    des caches Python

    des fichiers temporaires
    

✅ Avantages de .dockerignore :

    Construction plus rapide

    Image plus légère

    Moins de risques de fuite de données sensibles

    Meilleures pratiques de sécurité et performance