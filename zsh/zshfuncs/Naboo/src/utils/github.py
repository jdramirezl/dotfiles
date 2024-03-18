import git


class GitHub:
    def __init__(self):
        self.repo = git.Repo(".")
        self.git = self.repo.git

    def get_branches(self):
        return self.repo.heads

    def get_commits(self, branch: str = "master"):
        return self.repo.iter_commits(branch)

    def get_commit(self, commit: str):
        return self.repo.commit(commit)

    def get_repo_url(self):
        return self.repo.remotes.origin.url

    def get_repo_name(self):
        return self.repo.remotes.origin.url.split("/")[-1].replace(".git", "")

    def get_repo_commiters(self):
        return self.git.shortlog("-sne")

    # Get the root path of the current repository
    def get_repo_root(self):
        return self.repo.working_dir

    def get_user(self):
        return self.git.config("user.name")

    def get_user_email(self):
        return self.git.config("user.email")
    
    def get_user_from_commit(self, commit: str):
        try:
            return self.repo.commit(commit).author.name
        except:
            return "Unknown"
    
    def get_user_email_from_commit(self, commit: str):
        try:
            return self.repo.commit(commit).author.email
        except:
            return "Unknown"
        
    def get_usernames_from_email(self, email: str):
        return self.git.log("--all", "--author=" + email).split("\n")

    def get_commit_message(self, commit: str):
        return self.repo.commit(commit).message
