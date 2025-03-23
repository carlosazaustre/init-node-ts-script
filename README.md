[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Description

This tool allows you to quickly initialize a Node.js project with TypeScript fully configured and ready to use. The main goal is to save time and effort by eliminating the need to manually create each configuration file, install dependencies one by one, and configure each tool from scratch.

With this script, you get a complete modern development environment in seconds, with all essential tools preconfigured according to best practices. What would normally take hours of manual setup is reduced to a simple command, allowing you to immediately focus on what really matters: developing your application.

## Features

- Ready to use TypeScript
- ESLint and Prettier configured
- Husky for git hooks
- Commit validation with commitlint
- GitHub Actions CI configured
- Environment variables support with dotenv

## Installation

```bash
# Clone the repository
git clone https://github.com/username/$(basename "$PWD").git
cd $(basename "$PWD")

# Install dependencies
npm install
```

## Usage

### Development

To start the development server:

```bash
npm run dev
```

### Build

To compile the project:

```bash
npm run build
```

### Production

To run the compiled version:

```bash
npm start
```

## Available Scripts

- `npm run dev`: Starts the development server with hot-reload
- `npm run build`: Compiles the project for production
- `npm start`: Runs the compiled version of the project
- `npm run lint`: Runs the linter to check the code

## Project Structure

```
├── .github/               # GitHub Actions configuration
├── node_modules/          # Dependencies (generated)
├── src/                   # Source code
├── dist/                  # Compiled code (generated)
├── .env                   # Environment variables
├── .eslintrc.json         # ESLint configuration
├── .gitignore             # Files ignored by git
├── .prettierrc            # Prettier configuration
├── package.json           # Dependencies and scripts
└── tsconfig.json          # TypeScript configuration
```

## License

&copy; Carlos Azaustre.

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
