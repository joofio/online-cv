# Online CV - Jekyll Portfolio

This is a personal portfolio and blog website built with Jekyll and the Minimal Mistakes theme.

## Prerequisites

- Ruby 3.2.0 (specified in `.ruby-version`)
- Bundler
- A GitHub personal access token (for local development)

## GitHub API Credentials Setup

This project uses the `jekyll-github-metadata` plugin (included in the `github-pages` gem), which requires GitHub API credentials to work properly. Without these credentials, you'll encounter errors like:

```
The GitHub API credentials you provided aren't valid.
```

### For Local Development

1. **Create a GitHub Personal Access Token:**
   - Go to [GitHub Settings > Developer Settings > Personal Access Tokens > Tokens (classic)](https://github.com/settings/tokens)
   - Click "Generate new token (classic)"
   - Give it a descriptive name (e.g., "Jekyll Online CV Development")
   - Select the `public_repo` scope (or `repo` for private repositories)
   - Click "Generate token"
   - **Important:** Copy the token immediately - you won't be able to see it again!

2. **Set the environment variable:**

   **On Linux/macOS:**
   ```bash
   export JEKYLL_GITHUB_TOKEN=your_personal_access_token_here
   ```

   **On Windows (PowerShell):**
   ```powershell
   $env:JEKYLL_GITHUB_TOKEN="your_personal_access_token_here"
   ```

   **On Windows (CMD):**
   ```cmd
   set JEKYLL_GITHUB_TOKEN=your_personal_access_token_here
   ```

   For a permanent solution, add this to your shell profile (`.bashrc`, `.zshrc`, etc.) or use a tool like `direnv`.

### For GitHub Actions (Already Configured)

The GitHub Actions workflow is already configured to use the `JEKYLL_GITHUB_TOKEN` secret. To set it up:

1. Go to your repository settings on GitHub
2. Navigate to "Secrets and variables" > "Actions"
3. Click "New repository secret"
4. Name: `JEKYLL_GITHUB_TOKEN`
5. Value: Your personal access token (created as described above)
6. Click "Add secret"

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/joofio/online-cv.git
   cd online-cv
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

## Usage

### Local Development

Run the development server:

```bash
JEKYLL_GITHUB_TOKEN=your_token_here bundle exec jekyll serve
```

Or if you've already exported the environment variable:

```bash
bundle exec jekyll serve
```

The site will be available at `http://localhost:4000`

### Building for Production

```bash
JEKYLL_GITHUB_TOKEN=your_token_here bundle exec jekyll build
```

The built site will be in the `_site` directory.

## Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the `master` branch. The deployment is handled by the GitHub Actions workflow in `.github/workflows/jekyll.yml`.

## Troubleshooting

### Error: "The GitHub API credentials you provided aren't valid"

This means the `JEKYLL_GITHUB_TOKEN` environment variable is not set or is invalid. Follow the steps in the "GitHub API Credentials Setup" section above.

### Error: "API rate limit exceeded"

This happens when the GitHub API is called too many times without authentication. Set the `JEKYLL_GITHUB_TOKEN` environment variable to increase your rate limit from 60 to 5000 requests per hour.

### Error: "cannot load such file -- webrick"

Ruby 3.0+ removed webrick from the standard library. It's already included in the Gemfile, but if you encounter this error, run:

```bash
bundle add webrick
```

## License

See the original theme licenses in `Readme.txt`.
