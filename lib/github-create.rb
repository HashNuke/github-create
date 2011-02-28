class GithubCreate

  def self.resetCredentials
    puts "credentials reset"
  end

  def self.setupRepo(repo, remote, access)
    createLocalRepo unless checkIfLocalRepoExists

    # TODO check for username stored in .github-create or get username
    
    # get password from user
    pw = gets
    
   
    # if cannot create repo return
    unless createRepo(remote, access)
      return
    end

    # get remote url of the repo
    remoteUrl = getRemoteUrl(repo, pw)

    if remoteUrl.nil?
      puts "something went wrong..."
      return
    end
    
    unless setupRemote
      return
    end
    
    puts "setup done"
  end
  
  
  def self.createRepo(repo, access)
    # TODO
  end

  def self.createLocalRepo
    system('git init')
    puts "Create local repo: git init"
  end
  
  def self.checkIfLocalRepoExists
    return false if `git status -s`.length == 0
    return true
  end

  def setupRemote(remoteName, remoteUrl)
    # check for remote and create it
    if checkRemoteExists(remoteName)
      if remoteName == "origin"
        remoteName = "github"
        addRemote(remoteName, remoteUrl) unless checkRemoteExists(remoteName)
      else
        puts "Seems like remote with that name already exists!"
        puts "Here's the remote url of the repo to add it yourself: " << remoteUrl
        return false
      end
    else
      addRemote(remoteName, remoteUrl)
    end
      
    # control flow reaches here only if remote is added, so display msg
    puts "Added remote " << remoteName << " with url " << remoteUrl
    return true
  end

  def self.checkIfRemoteExists(remote)
    return true if system("git remote show "<< remote)
    return false
  end

  def self.addRemote(remoteName, remoteUrl)
    return true if system("git remote add " << remoteName << " " << remoteUrl)
    return false
  end

  def getRemoteUrl(repo)
    # TODO
  end
  
end
