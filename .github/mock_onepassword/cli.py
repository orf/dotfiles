# {{ onepasswordRead "op://chezmoi/ssh/public key" }}
# {{ onepasswordRead "op://chezmoi/github/password" | quote }}
# set -gx GITLAB_TOKEN {{ onepasswordRead "op://chezmoi/gitlab/password" | quote }}
# {{ onepasswordRead "op://chezmoi/ssh/private key" }}

def main():
    pass


if __name__ == '__main__':
    main()
