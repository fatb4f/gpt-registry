# template

`template/` is the scaffold authority for future ChatGPT project packs in
`gpt-registry`.

It is not a live project pack. It defines reusable structure, rendering
surfaces, and projection semantics so new project packs can be instantiated
deterministically instead of copied by hand.

The first explicit template layer is the `rsjsonnet` projection surface under
`template/project/render/jsonnet/`.
