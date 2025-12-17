# Evgeniy Gantman - Security Portfolio

A Hugo-based portfolio website showcasing 15+ years of cloud security, PCI DSS compliance, and DevSecOps expertise.

## Features

- 🚀 **Fast & Responsive:** Built with Hugo static site generator
- 🔒 **Security Focused:** Showcases PCI DSS, AWS Security, Kubernetes security expertise
- 📱 **Mobile First:** Fully responsive design
- 📊 **Metrics Display:** Key achievements and results
- 📝 **Blog System:** Technical articles and insights
- 🎨 **Modern Design:** Clean, professional interface
- 🔍 **SEO Optimized:** Proper meta tags and structured data

## Quick Start

### Prerequisites
- [Hugo](https://gohugo.io/installation/) (Extended version recommended)
- Git

### Local Development

```bash
# Clone repository
git clone <repository-url>
cd gantman-site

# Start development server
hugo server -D

# Open browser at http://localhost:1313
```

### Build for Production

```bash
# Build site
hugo --minify

# Output will be in public/ directory
```

## Project Structure

```
gantman-site/
├── archetypes/          # Content templates
├── content/            # Website content
│   ├── about/         # About page
│   ├── journey/       # Career journey
│   ├── projects/      # Project case studies
│   ├── skills/        # Technical skills
│   ├── blog/          # Blog articles
│   └── contact/       # Contact page
├── data/              # Data files (metrics.json)
├── layouts/           # HTML templates
├── static/            # Static assets (CSS, JS, images)
├── themes/            # Custom theme
└── config.toml        # Site configuration
```

## Content Management

### Adding New Project

```bash
hugo new projects/my-new-project.md
```

### Adding New Blog Post

```bash
hugo new blog/my-new-article.md
```

### Front Matter Example

```yaml
---
title: "Project Title"
date: 2024-01-15
description: "Project description"
technologies: ["AWS", "Kubernetes", "Terraform"]
categories: ["Security", "Cloud"]
tags: ["PCI DSS", "Compliance", "AWS"]
metrics:
  - "Metric 1"
  - "Metric 2"
---
```

## Deployment

### GitHub Pages (Automated)

The site is configured for automatic deployment to GitHub Pages via GitHub Actions. Push to the `main` branch triggers automatic build and deployment.

### Manual Deployment

1. Build the site: `hugo --minify`
2. Deploy the `public/` directory to your hosting provider

## Customization

### Colors
Edit CSS variables in `themes/gantman-security/static/css/theme.css`:
```css
:root {
  --primary: #1a365d;
  --secondary: #2c7a7b;
  --accent: #d69e2e;
}
```

### Configuration
Edit `config.toml` for site-wide settings:
```toml
[params]
  heroTitle = "Evgeniy Gantman"
  heroSubtitle = "Senior Cloud Security Architect"
  email = "your-email@example.com"
```

## Performance

- **Lighthouse Score:** 95+ (target)
- **Load Time:** < 2 seconds
- **SEO Score:** 90+ (target)

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## License

MIT License - see LICENSE file for details.

## Author

Evgeniy Gantman - [LinkedIn](https://linkedin.com/in/evgeniy-gantman) | [GitHub](https://github.com/gantmane)

---

*Last Updated: March 2025*
