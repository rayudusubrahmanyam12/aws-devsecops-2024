# Java Setup
sudo apt install openjdk-17-jdk -y
java -version
sudo apt install -y maven
mvn -v

# Jenkins Installation
sudo apt update
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo usermod -a -G docker jenkins
sudo su -
echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo ufw allow 8080
sudo ufw allow ssh
sudo ufw enable
sudo ufw status

# Helm Setup
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

