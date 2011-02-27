class GithubCreate

  def self.resetCredentials
    puts "credentials reset"
  end

  def self.setupRepo(repo, remote, access)
    createLocalRepo unless checkIfLocalRepoExists

    # TODO check for username stored in .github-create or get username
    
    # get password from user
    pw = gets
    
   
    # create remote repo
    if createRepo(remote, access)
      
    else
      return
    end

    remoteUrl = getRemoteUrl(repo, pw)

    if remoteUrl.nil?
      puts "something went wrong..."
      return
    end
    
    # check for remote and create it
    if checkRemoteExists(remote)
      if remote == "origin"
        remote = "github"
        addRemote(remote) unless checkRemoteExists(remote)
      else
        puts "Seems like remote with that name already exists!"
        puts "Here's the remote url of the repo to add it yourself: " << remoteUrl
        return
      end
    else
      addRemote(remote)
    end
    
    # control flow reaches here only if remote is added, so display msg
    puts "Added remote " << remote << " with url " << remoteUrl
      
    puts "setup done"
    
  end
  
  
  def self.createRepo(repo, access)
    
  end

  def self.createLocalRepo
    system('git init')
    puts "Create local repo: git init"
  end
  
  def self.checkIfLocalRepoExists
    return false if `git status -s`.length == 0
    return true
  end

  def self.checkIfRemoteExists
  end

  def self.addRemote()
  end

  def getRemoteUrl(repo)
  end
  
end
