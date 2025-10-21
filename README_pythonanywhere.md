PythonAnywhere deployment notes for this project

1) WSGI file snippet (paste into the PythonAnywhere WSGI editor). Replace <your-username> with your PythonAnywhere username (e.g., VincentMelato):

```python
import os
import sys

project_home = '/home/<your-username>/myprofile'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myprofile.settings')

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

2) PythonAnywhere Web tab settings
- Source code: /home/<your-username>/myprofile   (this directory must contain manage.py)
- Working directory: /home/<your-username>/myprofile
- Virtualenv: /home/<your-username>/.virtualenvs/myprofile-venv
- WSGI config: use the snippet above

3) Static files mapping
- URL: /static/
- Directory: /home/<your-username>/myprofile/staticfiles

4) Environment variables (set in Web tab "Environment variables")
- SECRET_KEY: <a secure random string>
- DEBUG: False
- (optional) CLOUDINARY_URL, DATABASE_URL, etc.

5) Quick console commands to run on PythonAnywhere once the repo is in place
```bash
# from Bash console on PythonAnywhere
cd $HOME/myprofile
bash deploy_pythonanywhere.sh
```

git add docs/
git commit -m "Add static site for GitHub Pages"
git push origin main