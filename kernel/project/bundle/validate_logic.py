#!/usr/bin/env python3

from __future__ import annotations

import json
from pathlib import Path
import sys

import yaml


PROJECT_ROOT = Path(__file__).resolve().parent.parent
PACKAGE_ROOT = PROJECT_ROOT.parent
TESTS_PATH = PROJECT_ROOT / "validation" / "logic-tests.yaml"
REPORT_PATH = PROJECT_ROOT / "bundle" / "logic-validation.report.json"


def fail(message: str) -> None:
    print(message, file=sys.stderr)
    sys.exit(1)


def main() -> None:
    if not TESTS_PATH.exists():
      fail(f"missing test suite: {TESTS_PATH}")

    suite_doc = yaml.safe_load(TESTS_PATH.read_text())
    if not isinstance(suite_doc, dict):
        fail("logic test suite must be a mapping")

    suite = suite_doc.get("suite")
    cases = suite_doc.get("cases")
    if not isinstance(suite, dict):
        fail("suite section missing or invalid")
    if not isinstance(cases, list) or not cases:
        fail("cases section missing or empty")

    required_suite_keys = {
        "id",
        "version",
        "issue_ref",
        "evaluated_bundle_ref",
        "evaluated_sources_root",
        "purpose",
        "pass_rule",
    }
    missing_suite_keys = sorted(required_suite_keys - set(suite))
    if missing_suite_keys:
        fail(f"suite is missing keys: {', '.join(missing_suite_keys)}")

    bundle_ref = suite["evaluated_bundle_ref"]
    sources_root = suite["evaluated_sources_root"]
    missing_paths = []
    for ref in (bundle_ref, sources_root):
        rel = Path(str(ref).replace("kernel/", "", 1))
        if not (PACKAGE_ROOT / rel).exists():
            missing_paths.append(ref)
    if missing_paths:
        fail(f"suite references missing paths: {', '.join(missing_paths)}")

    seen_ids = set()
    case_reports = []
    for case in cases:
        if not isinstance(case, dict):
            fail("each case must be a mapping")
        required_case_keys = {
            "id",
            "question",
            "required_refs",
            "expected_facts",
            "forbidden_claims",
        }
        missing_case_keys = sorted(required_case_keys - set(case))
        if missing_case_keys:
            fail(f"case missing keys: {', '.join(missing_case_keys)}")
        case_id = case["id"]
        if case_id in seen_ids:
            fail(f"duplicate case id: {case_id}")
        seen_ids.add(case_id)

        for field in ("required_refs", "expected_facts", "forbidden_claims"):
            if not isinstance(case[field], list) or not case[field]:
                fail(f"{case_id}: {field} must be a non-empty list")

        unresolved_refs = []
        for ref in case["required_refs"]:
            rel = Path(str(ref).replace("kernel/", "", 1))
            if not (PACKAGE_ROOT / rel).exists():
                unresolved_refs.append(ref)
        if unresolved_refs:
            fail(f"{case_id}: missing required refs: {', '.join(unresolved_refs)}")

        case_reports.append(
            {
                "id": case_id,
                "required_ref_count": len(case["required_refs"]),
                "expected_fact_count": len(case["expected_facts"]),
                "forbidden_claim_count": len(case["forbidden_claims"]),
                "status": "VALID",
            }
        )

    report = {
        "artifact_type": "gpt_project_logic_validation_report",
        "artifact_version": "0.1.0",
        "suite_id": suite["id"],
        "case_count": len(cases),
        "status": "PASS",
        "cases": case_reports,
    }
    REPORT_PATH.write_text(json.dumps(report, indent=2) + "\n")
    print(REPORT_PATH)


if __name__ == "__main__":
    main()
