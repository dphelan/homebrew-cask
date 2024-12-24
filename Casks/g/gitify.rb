cask "gitify" do
  version "5.17.0"
  sha256 "e61077d2301abe37a97cce4819fcd0762335d01cf6f0e38d07bfcc86a4d58cdc"

  url "https://github.com/gitify-app/gitify/releases/download/v#{version}/Gitify-#{version}-universal-mac.zip"
  name "Gitify"
  desc "GitHub notifications on your menu bar"
  homepage "https://github.com/gitify-app/gitify"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Gitify.app"

  preflight do
    retries ||= 3
    ohai "Attempting to close Gitify.app to avoid unwanted user intervention" if retries >= 3
    return unless system_command "/usr/bin/pkill", args: ["-f", "/Applications/Gitify.app"]
  rescue RuntimeError
    sleep 1
    retry unless (retries -= 1).zero?
    opoo "Unable to forcibly close Gitify.app"
  end

  uninstall quit: [
    "com.electron.gitify",
    "com.electron.gitify.helper",
  ]

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.electron.gitify.sfl*",
    "~/Library/Application Support/gitify",
    "~/Library/Caches/com.electron.gitify*",
    "~/Library/Caches/gitify-updater",
    "~/Library/HTTPStorages/com.electron.gitify",
    "~/Library/Preferences/com.electron.gitify*.plist",
    "~/Library/Saved Application State/com.electron.gitify.savedState",
  ]
end
