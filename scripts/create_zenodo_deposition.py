#!/usr/bin/env python3
"""
Create Zenodo deposition via API.
Usage: python create_zenodo_deposition.py --sandbox --metadata .zenodo.json --paper-dir structures/paper/...
"""

import argparse
import json
import os
from pathlib import Path

import requests


ZENODO_URL = "https://zenodo.org"
ZENODO_SANDBOX_URL = "https://sandbox.zenodo.org"


def create_deposition(base_url: str, token: str, metadata: dict) -> dict:
    headers = {"Content-Type": "application/json"}
    params = {"access_token": token}

    data = {
        "metadata": {
            "title": metadata["title"],
            "upload_type": metadata.get("upload_type", "publication"),
            "publication_type": metadata.get("publication_type", "preprint"),
            "description": metadata["description"],
            "creators": metadata["creators"],
            "keywords": metadata.get("keywords", []),
            "license": metadata.get("license", "CC-BY-4.0"),
            "access_right": metadata.get("access_right", "open"),
        }
    }

    response = requests.post(
        f"{base_url}/api/deposit/depositions",
        params=params,
        headers=headers,
        data=json.dumps(data),
    )

    if response.status_code != 201:
        print(f"Error creating deposition: {response.status_code}")
        print(response.text)
        return None

    return response.json()


def upload_file(base_url: str, token: str, deposition_id: str, file_path: Path) -> bool:
    params = {"access_token": token}
    url = f"{base_url}/api/deposit/depositions/{deposition_id}/files"

    with open(file_path, "rb") as f:
        files = {"file": (file_path.name, f)}
        response = requests.post(url, params=params, files=files)

    if response.status_code != 201:
        print(f"Error uploading file: {response.status_code}")
        print(response.text)
        return False

    return True


def publish_deposition(base_url: str, token: str, deposition_id: str) -> dict:
    params = {"access_token": token}
    url = f"{base_url}/api/deposit/depositions/{deposition_id}/actions/publish"

    response = requests.post(url, params=params)

    if response.status_code != 202:
        print(f"Error publishing deposition: {response.status_code}")
        print(response.text)
        return None

    return response.json()


def main():
    parser = argparse.ArgumentParser(description="Create Zenodo deposition")
    parser.add_argument("--sandbox", action="store_true", help="Use Zenodo sandbox")
    parser.add_argument("--metadata", required=True, help="Path to .zenodo.json")
    parser.add_argument("--paper-dir", required=True, help="Path to paper directory")
    parser.add_argument("--publish", action="store_true", help="Publish after upload")
    args = parser.parse_args()

    base_url = ZENODO_SANDBOX_URL if args.sandbox else ZENODO_URL
    token_env = "ZENODO_SANDBOX_TOKEN" if args.sandbox else "ZENODO_TOKEN"
    token = os.environ.get(token_env)

    if not token:
        print(f"Error: {token_env} environment variable not set")
        return 1

    with open(args.metadata, "r", encoding="utf-8-sig") as f:
        metadata = json.load(f)

    print(f"Creating deposition on {'sandbox' if args.sandbox else 'production'}...")
    print(f"  Title: {metadata['title']}")

    deposition = create_deposition(base_url, token, metadata)
    if not deposition:
        return 1

    deposition_id = deposition["id"]
    print(f"  Deposition ID: {deposition_id}")
    print(f"  DOI: {deposition.get('doi', 'pending')}")

    paper_dir = Path(args.paper_dir)
    tex_file = paper_dir / "main.tex"

    if tex_file.exists():
        print(f"  Uploading: {tex_file.name}")
        if upload_file(base_url, token, deposition_id, tex_file):
            print("  Upload successful")
        else:
            print("  Upload failed")

    if args.publish:
        print("  Publishing...")
        result = publish_deposition(base_url, token, deposition_id)
        if result:
            print(f"  Published DOI: {result.get('doi', 'N/A')}")
    else:
        print("  Note: Deposition is in draft mode. Publish manually or use --publish")

    print(f"\n  URL: {base_url}/record/{deposition_id}")

    print(f"::set-output name=deposition_id::{deposition_id}")
    print(f"::set-output name=doi::{deposition.get('doi', 'pending')}")
    print(f"::set-output name=url::{base_url}/record/{deposition_id}")

    return 0


if __name__ == "__main__":
    exit(main())
