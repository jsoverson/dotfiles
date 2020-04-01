echo "Writing current settings"
defaults read > /tmp/defaults-a
defaults -currentHost read > /tmp/defaults-currentHost-a
defaults read -globalDomain > /tmp/defaults-globalDomain-a
defaults -currentHost read -globalDomain > /tmp/defaults-currentHost-globalDomain-a
echo 'Press any key to continue...'
read  -n 1 
echo "Writing new settings"
defaults read > /tmp/defaults-b
defaults -currentHost read > /tmp/defaults-currentHost-b
defaults read -globalDomain > /tmp/defaults-globalDomain-b
defaults -currentHost read -globalDomain > /tmp/defaults-currentHost-globalDomain-b
echo "read"
diff /tmp/defaults-a /tmp/defaults-b
echo "-currentHost read"
diff /tmp/defaults-currentHost-a /tmp/defaults-currentHost-b
echo "read -globalDomain"
diff /tmp/defaults-globalDomain-a /tmp/defaults-globalDomain-b
echo "-currentHost read -globalDomain"
diff /tmp/defaults-globalDomain-a /tmp/defaults-globalDomain-b
