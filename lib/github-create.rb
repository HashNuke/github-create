require 'etc'
require 'httparty'

class GithubCreate

  include HTTParty
  base_uri = "http://github.com/api/v2/json"
  
  def self.resetCredentials
    if File.exists? configFilePath
      begin
        File.delete configFilePath
        puts "Username in $HOME/.github-create cleared"
      rescue
        puts "Oops! could not config delete file"
      end
    end
  end

  def self.setupRepo(repo, remote, access)
    createLocalRepo unless checkIfLocalRepoExists

    pw = getCredentials

    # if cannot create repo return
    repoUrl = createRepo(repo, access, pw)
    if repoUrl.nil?
      puts "Oops! couldn't create repo"
      return
    end

    remoteUrl = repoUrl.sub("https://", "git@").sub("/",":") << ".git"

    # remote url of the repo
    # remoteUrl = getRemoteUrl(repo, pw)

    # setup remote in local repo
    unless setupRemote(remote, remoteUrl)
      return
    end
    
  end
  
  
  def self.createRepo(repo, access, pw)
    username = readCredentialsFromFile
    result = makeCreateRequest username, pw, repo, access

    if result.has_key?('error')
      puts "Error: " << result["error"]
      return nil
    else
      puts "Repository is at " << result["repository"]["url"]
      return result["repository"]["url"]
    end
    
  end

  def self.createLocalRepo
    system("git init")
    puts "Create local repo: git init"
  end
  
  def self.checkIfLocalRepoExists
    system("git status -s")
  end

  def self.setupRemote(remoteName, remoteUrl)
    # check for remote and create it
    if checkIfRemoteExists(remoteName)
      if remoteName == "origin"
        remoteName = "github"
        addRemote(remoteName, remoteUrl) unless checkIfRemoteExists(remoteName)
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
    return system("git remote show "<< remote << "> /dev/null 2>&1")
  end

  def self.addRemote(remoteName, remoteUrl)
    system("git remote add " << remoteName << " " << remoteUrl)
  end

  def self.getRemoteUrl(repo)
    # TODO. not required right now
  end

  # this returns the password for use in the other methods
  def self.getCredentials
    username = readCredentialsFromFile
    if username.nil?
      username = createConfigFile
    end
    print "Password for " << username << ": "

    system "stty -echo"
    pw = gets.chomp
    system "stty -echo"
    return pw
  end

  # only stores the github username
  def self.readCredentialsFromFile
    if File.exists? configFilePath
      username = File.open(configFilePath, "r").readlines.join ""
      return username
    else
      return nil
    end
  end

  def self.createConfigFile
    f = File.open configFilePath, "w+"
    print "Enter your github username: "
    username = gets.chomp
    f << username
    f.close
    return username
  end
  
  def self.configFilePath
    userDir = Etc.getpwuid.dir
    filePath = userDir << "/" << ".github-create"
  end

  def self.makeCreateRequest(username, pw, repoName, access)
    if access == :public
      accessKey = 1
    else
      accessKey = 0
    end

    options = {
      :query=>{
        :name=>repoName,
        :public=>accessKey
      }
    }

    basic_auth username, pw
    self.post('http://github.com/api/v2/json/repos/create', options)
  end
  
end
