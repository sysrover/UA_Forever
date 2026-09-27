"""Render or apply reviewed translations to canonical UA_Forever catalogs."""

from __future__ import annotations

import argparse
from pathlib import Path

from catalog_pipeline import apply_fragments, load_units, prepare_changes, write_fragments


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate a filled worklist and prepare canonical catalog updates."
    )
    parser.add_argument("worklist", type=Path, help="filled translations.json")
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--output", type=Path, default=Path("automation/results/ready"))
    parser.add_argument("--apply", action="store_true",
                        help="insert validated entries into canonical catalog tables")
    parser.add_argument("--update-existing", action="store_true",
                        help="allow an explicit reviewed correction to an existing translation")
    args = parser.parse_args()
    repo = args.repo.resolve()
    worklist = args.worklist.resolve()
    output = args.output if args.output.is_absolute() else repo / args.output
    units = load_units(worklist)
    fragments, decisions = prepare_changes(repo, units, update_existing=args.update_existing)
    write_fragments(output, fragments, decisions)
    rejected = [row for row in decisions if row["status"] == "rejected"]
    ready = [row for row in decisions if row["status"] == "ready"]
    print(f"Prepared {len(ready)} translations in {len(fragments)} catalog fragments at {output}")
    if rejected:
        print(f"Rejected {len(rejected)} entries; see apply_report.json")
    if args.apply:
        if rejected:
            print("Nothing applied because the worklist contains rejected entries.")
            return 2
        changed = apply_fragments(repo, fragments, units, decisions)
        print("Updated canonical catalogs:")
        for path in changed:
            print(f"  {path}")
    else:
        print("Review the fragments, then rerun with --apply to update the catalogs.")
    return 0 if not rejected else 1


if __name__ == "__main__":
    raise SystemExit(main())
