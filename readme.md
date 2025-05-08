```
docker build --platform linux/amd64 -t adm8/helm-secrets-gpg-sops:pokazaur .
docker push adm8/helm-secrets-gpg-sops:pokazaur

docker run --rm -it adm8/helm-secrets-gpg-sops:pokazaur 
```

# Example .gitlab-ci.yml snippet
```
image: adm8/helm-secrets-gpg-sops:pokazaur

variables:
  GPG_TTY: "/dev/tty"

deploy:
  stage: deploy
  script:
    # Import GPG private key (stored in CI variable)
    - echo "$GPG_PRIVATE_KEY" | gpg --batch --import
    
    # Configure gpg.conf to allow loopback pinentry
    - echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
   
    # Export GPG_TTY to avoid issues
    - export GPG_TTY=$(tty)
    
    # Decrypt secrets using helm secrets
    # Pass the passphrase via environment variable to gpg through helm secrets
    - export GPG_PASSPHRASE="$GPG_PASSPHRASE"
    
    # - helm secrets dec secrets.yaml
    - helm upgrade --install myapp ./chart -f secrets.yaml

```
