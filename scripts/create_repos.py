#!/usr/bin/env python3
"""
Create independent GitHub repositories for each paper.
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


PAPER_CONFIGS = [
    {"number": 1, "repo": "lsh-sfa", "title": "LSH-SFA: Spacetime Field Attention", "short": "LSH-SFA"},
    {"number": 2, "repo": "lsh-three-layer", "title": "LSH: Element-Observers Architecture", "short": "Three-Layer"},
    {"number": 3, "repo": "lsh-format", "title": "LSH Format: AI-Native Data Format", "short": "LSH-Format"},
    {"number": 4, "repo": "lsh-attention-comparison", "title": "Beyond Softmax: Linear Attention Comparison", "short": "Attention-Comparison"},
    {"number": 5, "repo": "lsh-tokenizer-free", "title": "Tokenizer-Free Networks", "short": "Tokenizer-Free"},
    {"number": 6, "repo": "lsh-autoregressive", "title": "LSH-SFA for Autoregressive Generation", "short": "Autoregressive"},
    {"number": 7, "repo": "lsh-spacetime-cognition", "title": "Spacetime Cognition Deficit", "short": "Spacetime-Cognition"},
    {"number": 8, "repo": "lsh-burn", "title": "LSH-Burn: Rust Implementation", "short": "LSH-Burn"},
    {"number": 9, "repo": "lsh-rules", "title": "LSH Rules: Self-Verifying System", "short": "LSH-Rules"},
    {"number": 10, "repo": "lsh-version-control", "title": "LSH Version Control", "short": "Version-Control"},
]

PAPER_DIRS = {
    "1": "structures/paper/architecture/architecture_lsh_sfa-20260511_130001-a3f8c2",
    "2": "structures/paper/architecture/architecture_three_layer-20260511_130001-a3f8c2",
    "3": "structures/paper/format/format_lsh_format-20260511_130001-a3f8c2",
    "4": "structures/paper/attention/attention_comparison-20260511_130001-a3f8c2",
    "5": "structures/paper/tokenizer/tokenizer_free-20260511_130001-a3f8c2",
    "6": "structures/paper/autoregressive/autoregressive_lsh_sfa-20260511_130001-a3f8c2",
    "7": "structures/paper/cognition/spacetime_cognition_deficit-20260511_130001-a3f8c2",
    "8": "structures/paper/burn/lsh_burn-20260511_130001-a3f8c2",
    "9": "structures/paper/rules/lsh_rules-20260511_130001-a3f8c2",
    "10": "structures/paper/version_control/lsh_version_control-20260511_130001-a3f8c2",
}

README_TEMPLATE = '''# {title}

{description}

## Citation

If you use this work, please cite:

```bibtex
@article{{{cite_key}_2026,
  title={{{title}}},
  author={{{author}}},
  year={{2026}},
  note={{Preprint}}
}}
```

## License

CC-BY-4.0

## Links

- [LSH Protocol](https://github.com/hengbo-li/lsh-protocol)
- [Author ORCID](https://orcid.org/0009-0000-5331-6656)
'''

GITIGNORE_CONTENT = '''*.aux
*.log
*.out
*.toc
*.lof
*.lot
*.fls
*.fdb_latexmk
*.synctex.gz
*.synctex.gz(busy)
*.pdf
*.bbl
*.bcf
*.blg
*.run.xml
'''


def run_cmd(cmd, cwd=None, check=True):
    """Run a shell command."""
    result = subprocess.run(cmd, shell=True, cwd=cwd, capture_output=True, text=True)
    if check and result.returncode != 0:
        print(f"Error running command: {cmd}")
        print(f"stdout: {result.stdout}")
        print(f"stderr: {result.stderr}")
        sys.exit(1)
    return result


def repo_exists(github_user, repo_name):
    """Check if a repository already exists."""
    result = run_cmd(f"gh repo view {github_user}/{repo_name}", check=False)
    return result.returncode == 0


def create_repo(github_user, repo_name, description):
    """Create a new GitHub repository."""
    if repo_exists(github_user, repo_name):
        print(f"  [SKIP] Repository {repo_name} already exists")
        return False
    
    result = run_cmd(f'gh repo create {repo_name} --public --description "{description}"', check=False)
    if result.returncode != 0:
        print(f"  [ERROR] Failed to create repository: {result.stderr}")
        return False
    
    print(f"  [OK] Created repository: https://github.com/{github_user}/{repo_name}")
    return True


def create_readme(paper_dir, repo_name, title):
    """Create README.md from .zenodo.json metadata."""
    zenodo_path = Path(paper_dir) / ".zenodo.json"
    
    if zenodo_path.exists():
        with open(zenodo_path, 'r', encoding='utf-8') as f:
            metadata = json.load(f)
        description = metadata.get('description', '')
        author = metadata.get('creators', [{}])[0].get('name', 'Li, Hengbo')
    else:
        description = f"Paper: {title}"
        author = "Li, Hengbo"
    
    cite_key = repo_name.replace('-', '_')
    
    return README_TEMPLATE.format(
        title=title,
        description=description,
        cite_key=cite_key,
        author=author
    )


def setup_repo_files(temp_dir, paper_dir, repo_name, title):
    """Set up repository files."""
    paper_path = Path(paper_dir)
    temp_path = Path(temp_dir)
    
    main_tex = paper_path / "main.tex"
    zenodo_json = paper_path / ".zenodo.json"
    
    if not main_tex.exists():
        print(f"  [ERROR] main.tex not found in {paper_dir}")
        return False
    
    temp_path.mkdir(parents=True, exist_ok=True)
    
    run_cmd(f"cp {main_tex} {temp_path}/main.tex")
    
    if zenodo_json.exists():
        run_cmd(f"cp {zenodo_json} {temp_path}/.zenodo.json")
    
    readme_content = create_readme(paper_dir, repo_name, title)
    with open(temp_path / "README.md", 'w', encoding='utf-8') as f:
        f.write(readme_content)
    
    with open(temp_path / ".gitignore", 'w', encoding='utf-8') as f:
        f.write(GITIGNORE_CONTENT)
    
    return True


def push_to_repo(temp_dir, github_user, repo_name):
    """Push files to the repository."""
    temp_path = Path(temp_dir)
    
    run_cmd("git init", cwd=temp_dir)
    run_cmd("git add -A", cwd=temp_dir)
    run_cmd('git commit -m "feat: initial commit"', cwd=temp_dir)
    
    remote_url = f"https://x-access-token:{os.environ.get('GH_TOKEN', '')}@github.com/{github_user}/{repo_name}.git"
    run_cmd(f"git remote add origin {remote_url}", cwd=temp_dir)
    run_cmd("git push -u origin main", cwd=temp_dir)
    
    print(f"  [OK] Pushed files to {repo_name}")
    return True


def create_release(repo_name, title):
    """Create a GitHub release."""
    result = run_cmd(
        f'gh release create v1.0.0 --title "v1.0.0 - Initial Release" --notes "First release of {title}"',
        check=False
    )
    
    if result.returncode == 0:
        print(f"  [OK] Created release v1.0.0")
        return True
    else:
        print(f"  [WARN] Could not create release: {result.stderr}")
        return False


def main():
    parser = argparse.ArgumentParser(description='Create paper repositories')
    parser.add_argument('--start', type=int, default=1, help='Start paper number')
    parser.add_argument('--end', type=int, default=10, help='End paper number')
    parser.add_argument('--github-user', default='nameislihengbo', help='GitHub username')
    parser.add_argument('--create-release', action='store_true', help='Create GitHub release')
    parser.add_argument('--dry-run', action='store_true', help='Dry run mode')
    args = parser.parse_args()
    
    base_dir = Path(__file__).parent.parent
    os.chdir(base_dir)
    
    print("=" * 50)
    print("  CREATE PAPER REPOSITORIES")
    print("=" * 50)
    print(f"\n  Papers: {args.start} to {args.end}")
    print(f"  GitHub User: {args.github_user}")
    print(f"  Create Release: {args.create_release}")
    print()
    
    results = []
    
    for i in range(args.start - 1, args.end):
        config = PAPER_CONFIGS[i]
        paper_num = config['number']
        repo_name = config['repo']
        title = config['title']
        paper_dir = PAPER_DIRS[str(paper_num)]
        
        print(f"\n{'='*50}")
        print(f"  Paper {paper_num}: {repo_name}")
        print(f"{'='*50}")
        
        if args.dry_run:
            print(f"  [DRY RUN] Would create {repo_name}")
            results.append({'paper': paper_num, 'repo': repo_name, 'status': 'DRY_RUN'})
            continue
        
        created = create_repo(args.github_user, repo_name, title)
        
        if created:
            temp_dir = f"/tmp/{repo_name}"
            
            if setup_repo_files(temp_dir, paper_dir, repo_name, title):
                push_to_repo(temp_dir, args.github_user, repo_name)
                
                if args.create_release:
                    create_release(repo_name, title)
                
                results.append({'paper': paper_num, 'repo': repo_name, 'status': 'CREATED'})
            else:
                results.append({'paper': paper_num, 'repo': repo_name, 'status': 'ERROR', 'message': 'File setup failed'})
        else:
            results.append({'paper': paper_num, 'repo': repo_name, 'status': 'SKIPPED'})
    
    print("\n" + "=" * 50)
    print("  SUMMARY")
    print("=" * 50)
    
    for r in results:
        status_color = '\033[92m' if r['status'] == 'CREATED' else '\033[93m'
        print(f"  Paper {r['paper']}: {r['repo']} - {status_color}{r['status']}\033[0m")


if __name__ == '__main__':
    main()
