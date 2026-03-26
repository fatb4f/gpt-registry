# GPT Registry

This repository contains two separate project containers that mirror the linked ChatGPT project setup:

- `kernel/` is the authority and retrieval plane.
- `artifact-genai-loop/` is the execution and publication plane.

Use the local `AGENTS.md` in each project directory as the canonical instruction mirror for that project. Keep the kernel authoritative and keep the sidecar tightly docked to kernel-issued scope.

## Repo-wide rules

- Treat manifests as durable truth.
- Treat instructions as operating behavior.
- Do not invent missing contract fields, workflow states, or policy rules.
- When sources conflict, apply the declared source priority from the relevant kernel manifest.
- Separate facts, inferences, and recommendations.
- Keep generated outputs aligned to the registry contracts and their fingerprints.

## Project routing

- For authority and retrieval questions, follow `kernel/AGENTS.md`.
- For artifact generation and publication questions, follow `artifact-genai-loop/AGENTS.md`.
- When a task crosses both planes, honor the kernel-issued docking contract first.
