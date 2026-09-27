"""Parse an autoscan export and create checked translation worklists."""

from __future__ import annotations

import argparse
from pathlib import Path

from catalog_pipeline import (
    CatalogState,
    analyze,
    load_ignored_sources,
    parse_autoscan,
    write_worklists,
)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Classify a UA_Forever autoscan log against the effective catalogs."
    )
    parser.add_argument("log", type=Path, help="autoscan export text file")
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--output", type=Path, default=Path("automation/results"))
    parser.add_argument("--ignored-sources", type=Path,
                        default=Path("automation/ignored_sources.json"))
    args = parser.parse_args()
    repo = args.repo.resolve()
    log = args.log.resolve()
    output = args.output if args.output.is_absolute() else repo / args.output
    ignored_path = (args.ignored_sources if args.ignored_sources.is_absolute()
                    else repo / args.ignored_sources)
    records = parse_autoscan(log.read_text(encoding="utf-8-sig", errors="replace"))
    state = CatalogState(repo)
    result = analyze(records, state, load_ignored_sources(ignored_path))
    write_worklists(output, result, log, state.loaded_files, len(records))
    counts = {name: len(rows) for name, rows in sorted(result.items())}
    print(f"Parsed {len(records)} autoscan records into {output}")
    print("; ".join(f"{name}={count}" for name, count in counts.items()))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
