#!/usr/bin/env python3
"""
Build Release Script for FancyActionBar+
Creates a zip file of the addon folder with version number from manifest.
Supports both PC and Console releases.
"""

import os
import re
import zipfile
import sys
import shutil
import tempfile
from pathlib import Path

def get_version_from_manifest(manifest_path):
    """Extract version number from the addon manifest file."""
    try:
        with open(manifest_path, 'r', encoding='utf-8') as file:
            content = file.read()
            
        # Look for version line: ## Version: X.X.X
        version_match = re.search(r'##\s*Version:\s*(\d+\.\d+\.\d+)', content)
        if version_match:
            return version_match.group(1)
        else:
            print("Error: Could not find version in manifest file")
            return None
    except FileNotFoundError:
        print(f"Error: Manifest file not found at {manifest_path}")
        return None
    except Exception as e:
        print(f"Error reading manifest file: {e}")
        return None

def rename_for_console(source_folder, temp_dir):
    """Create a console version by renaming folder and updating file contents."""
    console_folder = temp_dir / "FancyActionBarPlus"
    
    # Copy the entire folder
    shutil.copytree(source_folder, console_folder)
    
    # Define the replacements to make
    replacements = {
        'FancyActionBar+': 'FancyActionBarPlus',
        'FAB+': 'FABP'
    }
    
    # File extensions to process
    text_extensions = {'.lua', '.xml', '.txt', '.addon', '.md'}
    
    # Process all files in the copied folder
    for file_path in console_folder.rglob('*'):
        if file_path.is_file():
            # Rename files if needed
            if 'FancyActionBar+' in file_path.name:
                new_name = file_path.name.replace('FancyActionBar+', 'FancyActionBarPlus')
                new_path = file_path.parent / new_name
                file_path.rename(new_path)
                file_path = new_path
            
            # Update file contents for text files
            if file_path.suffix.lower() in text_extensions:
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Apply replacements
                    modified = False
                    for old_text, new_text in replacements.items():
                        if old_text in content:
                            content = content.replace(old_text, new_text)
                            modified = True
                    
                    # Write back if modified
                    if modified:
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(content)
                        print(f"Updated: {file_path.relative_to(console_folder)}")
                
                except Exception as e:
                    print(f"Warning: Could not process {file_path}: {e}")
    
    return console_folder

def create_zip_archive(source_folder, output_path, exclude_patterns=None):
    """Create a zip archive of the source folder."""
    if exclude_patterns is None:
        exclude_patterns = ['.git', '__pycache__', '*.pyc', '.DS_Store', 'Thumbs.db']
    
    def should_exclude(path):
        """Check if a path should be excluded based on patterns."""
        path_str = str(path)
        for pattern in exclude_patterns:
            if pattern in path_str or path_str.endswith(pattern.replace('*', '')):
                return True
        return False
    
    try:
        with zipfile.ZipFile(output_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            source_path = Path(source_folder)
            
            for file_path in source_path.rglob('*'):
                if file_path.is_file() and not should_exclude(file_path):
                    # Create relative path for the zip file
                    arc_name = file_path.relative_to(source_path.parent)
                    zipf.write(file_path, arc_name)
                    print(f"Added: {arc_name}")
        
        return True
    except Exception as e:
        print(f"Error creating zip archive: {e}")
        return False

def main():
    """Main function to build the release."""
    import argparse
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Build release for FancyActionBar+')
    parser.add_argument('--pc-only', action='store_true', 
                       help='Build only PC version')
    parser.add_argument('--console-only', action='store_true',
                       help='Build only console version')
    args = parser.parse_args()
    
    script_dir = Path(__file__).parent
    addon_folder = script_dir / "FancyActionBar+"
    manifest_file = addon_folder / "FancyActionBar+.addon"
    
    # Check if addon folder exists
    if not addon_folder.exists():
        print(f"Error: Addon folder not found at {addon_folder}")
        sys.exit(1)
    
    # Check if manifest file exists
    if not manifest_file.exists():
        print(f"Error: Manifest file not found at {manifest_file}")
        sys.exit(1)
    
    # Get version from manifest
    version = get_version_from_manifest(manifest_file)
    if not version:
        sys.exit(1)
    
    success = True
    
    # Build PC version (default unless console-only is specified)
    if not args.console_only:
        success &= build_pc_version(script_dir, addon_folder, version)
    
    # Build console version (default unless pc-only is specified)
    if not args.pc_only:
        success &= build_console_version(script_dir, addon_folder, version)
    
    if success:
        print(f"\n✅ All builds completed successfully!")
    else:
        print(f"\n❌ Some builds failed!")
        sys.exit(1)

def build_pc_version(script_dir, addon_folder, version):
    """Build the PC version."""
    output_filename = f"FancyActionBar+_{version}.zip"
    output_path = script_dir / output_filename
    
    print(f"\n--- Building PC Release ---")
    print(f"Building release for FancyActionBar+ version {version}")
    print(f"Source folder: {addon_folder}")
    print(f"Output file: {output_path}")
    
    # Remove existing zip file if it exists
    if output_path.exists():
        output_path.unlink()
        print(f"Removed existing file: {output_filename}")
    
    # Create the zip archive
    if create_zip_archive(addon_folder, output_path):
        file_size = output_path.stat().st_size / 1024  # Size in KB
        print(f"📦 Created: {output_filename} ({file_size:.1f} KB)")
        return True
    else:
        print("❌ PC build failed!")
        return False

def build_console_version(script_dir, addon_folder, version):
    """Build the console version."""
    output_filename = f"FancyActionBarPlus_{version}.zip"
    output_path = script_dir / output_filename
    
    print(f"\n--- Building Console Release ---")
    print(f"Building console release for FancyActionBarPlus version {version}")
    print(f"Source folder: {addon_folder}")
    print(f"Output file: {output_path}")
    
    # Remove existing zip file if it exists
    if output_path.exists():
        output_path.unlink()
        print(f"Removed existing file: {output_filename}")
    
    # Create temporary directory for console version
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        
        # Create console version
        console_folder = rename_for_console(addon_folder, temp_path)
        
        # Create the zip archive
        if create_zip_archive(console_folder, output_path):
            file_size = output_path.stat().st_size / 1024  # Size in KB
            print(f"📦 Created: {output_filename} ({file_size:.1f} KB)")
            return True
        else:
            print("❌ Console build failed!")
            return False

if __name__ == "__main__":
    main()
