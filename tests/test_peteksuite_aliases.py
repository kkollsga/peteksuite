def test_layer_shorthand_aliases_import_the_real_modules():
    from peteksuite import pio, ps, pst, pto

    import petekio
    import peteksim
    import petekstatic
    import petektools

    assert pio is petekio
    assert pto is petektools
    assert pst is petekstatic
    assert ps is peteksim


def test_layer_shorthand_aliases_are_advertised():
    import peteksuite

    assert {"pio", "pto", "pst", "ps"}.issubset(set(peteksuite.__all__))
    assert {"pio", "pto", "pst", "ps"}.issubset(set(dir(peteksuite)))
