sudo apt-get install python2.6
sudo apt-get install python-pip
sudo apt-get install git
sudo apt-get install tree
sudo pip install virtualenv
sudo pip install virtualenvwrapper

while true; do
    read -p "Project name: " proj
    if [ "$proj" != "" ]; then
        break;
    fi
    echo "You must enter a project name!"
done
while true; do
    read -p "First application name: " app
    if [ "$app" != "" ]; then
        break;
    fi
    echo "You must enter a application name!"
done

if [[ -z "$WORKON_HOME" ]]; then
    export WORKON_HOME=~/.virtualenvs
#    export VIRTUALENVWRAPPER_PYTHON=`python -c "import sys;print '%s2.6'%sys.executable"`
    mkdir -p $WORKON_HOME
    echo "WORKON_HOME="$WORKON_HOME >> ~/.bashrc
    echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc
fi
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv --no-site-packages $proj
pip install django
pip install south
cp `locate django-admin.py -l 1` .
python django-admin.py startproject $proj
pip freeze > "$proj/requirements.txt"
mv django-admin.py $proj/
cd $proj/
python django-admin.py startapp $app
chmod +x manage.py
rm django-admin.py
git init
read -p "Enter your name (leave empty for `whoami`): " name
if [ "$name" == "" ]; then
    name=`whoami`
fi
git config user.name "$name"
echo "*.pyc" >> .gitignore
echo "*.pyo" >> .gitignore
echo "*~" >> .gitignore
echo "*.swp" >> .gitignore
echo "*.log" >> .gitignore
echo "*.pyc" >> .gitignore
echo "*.pid" >> .gitignore
echo "*.tmp" >> .gitignore

echo "[user]" >> .git/.gitconfig
echo "	name = " >> .git/.gitconfig
echo "[alias]" >> .git/.gitconfig
echo "	lll = log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(bold white)— %an%C(reset)' --abbrev-commit" >> .git/.gitconfig
git add .
git commit -am 'Initial commit'
echo '
'
echo "Project $proj created"
echo "App $app created"
echo "
"
cd ..
tree $proj
cd $proj
echo '
'
echo "Initialized Git repository user.name=$name"
echo "> git lll"
git lll
echo "Created virtualenv (to start working on project enter workon $proj and go to $proj/)"
