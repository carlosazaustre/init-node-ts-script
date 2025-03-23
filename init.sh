#!/bin/bash
# This script initializes a Node.js project with TypeScript, ESLint, Prettier, and Husky.
# It sets up a basic project structure, installs necessary dependencies, and configures Git and GitHub Actions.
# Check if the script is run from the root directory of the project


# Colors for messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Starting Node.js with TypeScript project setup...${NC}"

# Get Git information
GIT_NAME=$(git config --get user.name)
GIT_EMAIL=$(git config --get user.email)

if [ -z "$GIT_NAME" ] || [ -z "$GIT_EMAIL" ]; then
    echo "❌ Error: Git user.name or user.email are not configured"
    exit 1
fi

echo -e "${GREEN}✅ Initializing Node.js project${NC}"
npm init -y

echo -e "${GREEN}✅ Initializing Git repository${NC}"
git init

echo -e "${GREEN}✅ Creating .gitignore${NC}"
cat > .gitignore << EOF
# Dependencies
node_modules/
npm-debug.log
yarn-debug.log
yarn-error.log

# TypeScript
dist/
build/
*.tsbuildinfo

# Environment variables
.env
.env.local
.env.*.local

# IDE - VSCode
.vscode
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json

# System Files
.DS_Store
Thumbs.db

# Logs
logs
*.log

# Coverage directory used by tools like istanbul
coverage/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz
EOF

echo -e "${GREEN}✅ Creating README.md${NC}"
echo "# $(basename "$PWD")" > README.md

echo -e "${GREEN}✅ Creating LICENSE${NC}"
cat > LICENSE << EOF
MIT License

Copyright (c) $(date +%Y) $GIT_NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

echo -e "${GREEN}✅ Installing TypeScript dependencies${NC}"
npm install --save-dev typescript tsx pkgroll @types/node @types/jest

echo -e "${GREEN}✅ Creating tsconfig.json${NC}"
cat > tsconfig.json << EOF
{
  "\$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "Node",
    "strict": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true,
    "isolatedModules": true,
    "resolveJsonModule": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "noEmit": false,
    "types": ["node", "jest"],
    "verbatimModuleSyntax": false,
    "incremental": true,
    "allowJs": true
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules", "dist", "**/*.spec.ts", "**/*.test.ts"]
}

EOF

echo -e "${GREEN}✅ Installing and configuring ESLint${NC}"
npm install --save-dev eslint @eslint/js@9 @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-config-love

cat > eslint.config.js << EOF
import globals from 'globals'
import pluginJs from '@eslint/js'
import tseslint from 'typescript-eslint'
import love from 'eslint-config-love'

export default [
  {
    ...love, 
    files: ['**/*.{js,mjs,cjs,ts}']
  },
  {
    languageOptions: { globals: globals.node }
  },
  pluginJs.configs.recommended,
  ...tseslint.configs.recommended,
]
EOF

echo -e "${GREEN}✅ Installing and configuring Prettier${NC}"
npm install --save-dev prettier

cat > .prettierrc << EOF
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": false,
  "printWidth": 100,
  "tabWidth": 2,
  "endOfLine": "auto"
}
EOF

echo -e "${GREEN}✅ Installing lint-staged and husky${NC}"
npm install --save-dev lint-staged husky @commitlint/cli @commitlint/config-conventional

cat > .lintstagedrc << EOF
{
  "*.ts": ["prettier --list-different", "eslint"],
  "*.md": "prettier --list-different"
}
EOF

cat > commitlint.config.js << EOF
export default { extends: ['@commitlint/config-conventional'] };

EOF

echo -e "${GREEN}✅ Creating project structure${NC}"
mkdir -p src
cat > src/index.ts << EOF
import 'dotenv/config';

console.log('Hello Node');
console.log('Environment:', process.env.NODE_ENV);
EOF

echo -e "${GREEN}✅ Setting up environment variables${NC}"
echo "NODE_ENV=development" > .env

echo -e "${GREEN}✅ Setting up GitHub Actions${NC}"
mkdir -p .github/workflows

cat > .github/workflows/ci.yml << EOF
name: CI

on:
  pull_request:
    branches:
      - main
  push:
    branches:
      - main

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: "23"

      - name: Install dependencies
        run: npm install

      - name: Run linter
        run: npm run lint

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: "23"

      - name: Install dependencies
        run: npm install

      - name: Run tests
        run: npm test

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: "23"

      - name: Install dependencies
        run: npm install

      - name: Build TypeScript
        run: npm run build
EOF

echo -e "${GREEN}✅ Installing dotenv${NC}"
npm install dotenv

echo -e "${GREEN}✅ Setting up Husky${NC}"
# Inicializar husky con el nuevo comando
npx husky init

# Crear los hooks manualmente
echo "npm run lint" > .husky/pre-commit
echo "npx --no -- commitlint --edit \$1" > .husky/commit-msg
echo "npm run test" > .husky/pre-push

# Dar permisos de ejecución a los hooks
chmod +x .husky/pre-commit .husky/commit-msg .husky/pre-push

echo -e "${GREEN}✅ Configuring npm scripts${NC}"
npm install rimraf@4 -D
npm pkg set scripts.dev="tsx watch src/index.ts"
npm pkg set scripts.start="node dist/index.js"
npm pkg set scripts.build="rimraf dist && pkgroll --minify"
npm pkg set scripts.lint="eslint . --ext .ts ./src"
npm pkg set scripts.test="echo \"Error: no test specified\" && exit 1"
npm pkg set scripts.prepare="husky install"
npm pkg set type="module"
npm pkg set engines.node=">=22.0.0"
npm pkg set exports="./dist/index.js"
npm pkg set private=true
npm pkg set license="MIT"
npm pkg set author="$GIT_NAME <$GIT_EMAIL>"
npm pkg set repository.type="git"

echo "${BLUE}🎉 Project setup completed successfully!${NC}"
echo "${BLUE}📝 You can start developing with:${NC}"
echo "${GREEN}   npm run dev${NC}"
