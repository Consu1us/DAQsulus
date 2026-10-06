def prompter(text, default_value):
    val = input(f"{text} [default: {default_value}]: ").strip()
    return float(val) if val else float(default_value)
    