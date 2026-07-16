using SciMLTesting, FastPower, JET, Test

run_qa(FastPower; explicit_imports = true, api_docs_kwargs = (; rendered = true))
