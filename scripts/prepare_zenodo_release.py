#!/usr/bin/env python3
"""
Prepare Zenodo release metadata for a paper.
Usage: python prepare_zenodo_release.py --paper 1 --sandbox
"""

import argparse
import json
import shutil
from pathlib import Path

PAPER_DIRS = {
    "1": "structures/paper/architecture/architecture_lsh_sfa-20260511_130001-a3f8c2",
    "2": "structures/paper/architecture/architecture_three_layer-20260511_130002-b7d2e1",
    "3": "structures/paper/architecture/architecture_lsh_format-20260511_130003-h9j8k7",
    "4": "structures/paper/theory/theory_attention_comparison-20260511_120002-d5f4g3",
    "5": "structures/paper/theory/theory_tokenizer_free-20260511_120003-e6g5h4",
    "6": "structures/paper/applications/applications_autoregressive-20260511_150001-i10k9l8",
    "7": "structures/paper/foundational/foundational_spacetime_cognition-20260511_160001-j11k10m9",
    "8": "structures/paper/systems/systems_lsh_burn-20260511_140003-l13m14n15",
    "9": "structures/paper/applications/applications_lsh_rules-20260511_150002-m13n14o15",
    "10": "structures/paper/systems/systems_version_control-20260511_140004-p4q5r6",
}


def main():
    parser = argparse.ArgumentParser(description="Prepare Zenodo release")
    parser.add_argument("--paper", required=True, help="Paper number (1-10)")
    parser.add_argument("--sandbox", action="store_true", help="Use Zenodo sandbox")
    args = parser.parse_args()

    paper_num = args.paper
    if paper_num not in PAPER_DIRS:
        print(f"Error: Invalid paper number {paper_num}")
        return 1

    paper_dir = Path(PAPER_DIRS[paper_num])
    zenodo_json = paper_dir / ".zenodo.json"

    if not zenodo_json.exists():
        print(f"Error: {zenodo_json} not found")
        return 1

    with open(zenodo_json, "r", encoding="utf-8") as f:
        metadata = json.load(f)

    if args.sandbox:
        metadata["title"] = f"[SANDBOX TEST] {metadata['title']}"

    with open(".zenodo.json", "w", encoding="utf-8") as f:
        json.dump(metadata, f, indent=2, ensure_ascii=False)

    print(f"::set-output name=paper_dir::{paper_dir}")
    print(f"::set-output name=paper_title::{metadata['title']}")

    print(f"\nPrepared metadata for Paper {paper_num}:")
    print(f"  Title: {metadata['title']}")
    print(f"  Version: {metadata.get('version', 'N/A')}")
    print(f"  Source: {zenodo_json}")
    print(f"  Output: .zenodo.json")

    return 0


if __name__ == "__main__":
    exit(main())
