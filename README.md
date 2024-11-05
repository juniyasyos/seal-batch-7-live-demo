# Getting Started
* Install pyenv : https://github.com/pyenv/pyenv
  * `curl https://pyenv.run | bash`
  * run 
    ```bash
      eval "$(pyenv init -)"
      
      echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
      echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
      echo 'eval "$(pyenv init -)"' >> ~/.bashrc
      
      source ~/.bashrc
    ```
* Exit and open your terminal again
* Create .python-version and put which python version you want to install
* Run `pyenv install -s`
* To create python virtual environment, Run `python -m venv .venv`
* activate python : `source .venv/bin/activate`

# Ansible
```bash
ansible all -i inventory.ini -m ping --private-key=mykey.pem
```