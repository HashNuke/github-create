require 'etc'

class GithubCreate

  def self.resetCredentials
    if File.exists? configFilePath
      begin
        File.delete configFilePath
        puts "Username in $HOME/.github-create cleared"
      rescue
        puts "Oops! could not delete file"
      end
    end
  end

  def self.setupRepo(repo, remote, access)
    createLocalRepo unless checkIfLocalRepoExists

    pw = getCredentials

    # if cannot create repo return
    unless createRepo(remote, access)
      return
    end

    # get remote url of the repo
    remoteUrl = getRemoteUrl(repo, pw)

    # if remoteUrl is nil return
    if remoteUrl.nil?
      puts "something went wrong..."
      return
    end

    # setup remote in local repo
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

  # this returns the password for use in the other methods
  def getCredentials
    username = readCredentialsFromFile
    if username.nil?
      username = createConfigFile
    end
    puts "Password for " << username << ":"
    return gets
  end

  # only stores the github username
  def readCredentialsFromFile
    
    if File.exists? configFilePath
      username = File.open(configFilePath, "r").readlines.join ""
      puts username
      return username
    else
      return nil
    end
  end

  def createConfigFile
    f = File.open configFilePath, "w+"
    print "Enter your github username: "
    username = gets
    f << username
    f.close
    return username
  end
  
  def configFilePath
    userDir = Etc.getpwuid.dir
    filePath = userDir << "|" << ".github-create"
  end

end
