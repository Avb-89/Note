## ======================= How to add DS_Store to .gitignore =======================

`$ find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch`

`$ echo .DS_Store >> .gitignore`

`$ git add .gitignore`

`$ git commit -m '.DS_Store banished!'`