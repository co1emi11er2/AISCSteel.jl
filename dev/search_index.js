var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = AISCSteel","category":"page"},{"location":"#AISCSteel","page":"Home","title":"AISCSteel","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for AISCSteel.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [AISCSteel]","category":"page"},{"location":"#AISCSteel.classify_section_for_lb_case1-NTuple{4, Any}","page":"Home","title":"AISCSteel.classify_section_for_lb_case1","text":"classify_section_for_lb_case1(b, t, E, F_y)\n\nClassifies the section of a member subject to axial compression. \n\nDescription of applicable member: Flanges of rolled I-shaped sections, plates projecting from rolled I-shaped sections, outstanding legs of pairs of angles connected with continuous contact, flanges of channels, and flanges of tees. \n\nArguments\n\nb: width of the plate or half the width of the flange.\nt: thickness of the flange.\nE: elastic section modulous.\nF_y: yield strength of steel.\n\nReturns\n\nCompressionBucklingType enum whose value is either Nonslender or Slender\n\nReference\n\nAISC Table B4.1a\n\n\n\n\n\n","category":"method"},{"location":"#AISCSteel.classify_section_for_lb_case10-NTuple{4, Any}","page":"Home","title":"AISCSteel.classify_section_for_lb_case10","text":"classify_section_for_lb_case10(b, t, E, F_y)\n\nClassifies the compressive elements of a member subject to flexural. \n\nDescription of applicable member: Flanges of rolled I-shaped sections, channels, and tees. \n\nArguments\n\nb: width of the plate or half the width of the flange.\nt: thickness of the flange.\nE: elastic section modulous.\nF_y: yield strength of steel.\n\nReturns\n\nFlexureBucklingType enum whose value is either Compact, Noncompact, or Slender\n\nReference\n\nAISC Table B4.1b\n\n\n\n\n\n","category":"method"},{"location":"#AISCSteel.classify_section_for_lb_case13-NTuple{4, Any}","page":"Home","title":"AISCSteel.classify_section_for_lb_case13","text":"classify_section_for_lb_case13(b, t, E, F_y)\n\nClassifies the compressive elements of a member subject to flexural. \n\nDescription of applicable member: Flanges of all I-shaped sections and channels bent about their minor axis. \n\nArguments\n\nb: width of the plate or half the width of the flange.\nt: thickness of the flange.\nE: elastic section modulous.\nF_y: yield strength of steel.\n\nReturns\n\nFlexureBucklingType enum whose value is either Compact, Noncompact, or Slender\n\nReference\n\nAISC Table B4.1b\n\n\n\n\n\n","category":"method"},{"location":"#AISCSteel.classify_section_for_lb_case15-NTuple{4, Any}","page":"Home","title":"AISCSteel.classify_section_for_lb_case15","text":"classify_section_for_lb_case15(b, t, E, F_y)\n\nClassifies the compressive elements of a member subject to flexural. \n\nDescription of applicable member: Webs of doubly-symmetric I-shaped sections and channels. \n\nArguments\n\nh: \nFor rolled sections: the clear distance between flanges less the fillet at each flange.\nFor built-up sections: clear distance between flanges when welds are used.\nt_w: thickness of the web.\nE: elastic section modulous.\nF_y: yield strength of steel.\n\nReturns\n\nFlexureBucklingType enum whose value is either Compact, Noncompact, or Slender\n\nReference\n\nAISC Table B4.1b\n\n\n\n\n\n","category":"method"},{"location":"#AISCSteel.flexure_capacity_f2","page":"Home","title":"AISCSteel.flexure_capacity_f2","text":"function flexure_capacity_f2(E, G, F_y, Z_x, S_x, I_y, r_y, h_0, J, C_w, c, r_ts, L_b)\n\nCalculates the moment capacity of the applicable section.\n\nDescription of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. \n\nArguments\n\nE: modulous of elasticity (ksi)\nF_y: yield strength of steel (ksi)\nZ_x: plastic section modulous  (inch^4)\nS_x: elastic section modulous (inch^3)\nr_y: radius of gyration about the y-axis (inch)\nh_0: distance between the flange centroids (inch)\nJ: torsional constant (inch^4)\nc:\nr_ts:\nL_b: unbraced length (inch)\n\nReturns\n\nM_n: moment capacity of the section.\n\nReference\n\nAISC Section F2\n\n\n\n\n\n","category":"function"},{"location":"#AISCSteel.flexure_capacity_f3","page":"Home","title":"AISCSteel.flexure_capacity_f3","text":"flexure_capacity_f3(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass)\n\nCalculates the moment capacity of the applicable section.\n\nDescription of applicable member: Doubly symmetric I-shaped members with compact webs and noncompact or slender flanges bent about their major axis.\n\nArguments\n\nE: modulous of elasticity (ksi)\nF_y: yield strength of steel (ksi)\nZ_x: plastic section modulous  (inch^4)\nS_x: elastic section modulous (inch^3)\nr_y: radius of gyration about the y-axis (inch)\nh_0: distance between the flange centroids (inch)\nJ: torsional constant (inch^4)\nc:\nr_ts:\nL_b: unbraced length (inch)\nh: clear distance between flanges less the fillets (inch)\nt_w: thickness of the web (inch)\nλ_f: slenderness ratio of the flange\nλ_pf: compact slenderness ratio limit of the flange\nλ_rf: noncompact slenderness ratio limit of the flange\nλ_fclass: compact noncompact or slender\n\nReturns\n\nM_n: moment capacity of the section.\n\nReference\n\nAISC Section F3\n\n\n\n\n\n","category":"function"},{"location":"#AISCSteel.flexure_capacity_f4-NTuple{24, Any}","page":"Home","title":"AISCSteel.flexure_capacity_f4","text":"flexure_capacity_f4(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ, λ_pf, λ_rf, λ_fclass)\n\nCalculates the moment capacity of the applicable section.\n\nDescription of applicable member: Doubly symmetric I-shaped members with compact webs and noncompact or slender flanges bent about their major axis.\n\nArguments\n\nE: modulous of elasticity (ksi)\nF_y: yield strength of steel (ksi)\nZ_x: plastic section modulous  (inch^4)\nS_x: elastic section modulous (inch^3)\nr_y: radius of gyration about the y-axis (inch)\nh_0: distance between the flange centroids (inch)\nJ: torsional constant (inch^4)\nc:\nr_ts:\nL_b: unbraced length (inch)\nh: clear distance between flanges less the fillets (inch)\nt_w: thickness of the web (inch)\nλ_f: slenderness ratio of the flange\nλ_pf: compact slenderness ratio limit of the flange\nλ_rf: noncompact slenderness ratio limit of the flange\nλ_fclass: compact noncompact or slender\n\nReturns\n\nM_n: moment capacity of the section.\n\nReference\n\nAISC Section F4\n\n\n\n\n\n","category":"method"},{"location":"#AISCSteel.flexure_capacity_f5-NTuple{16, Any}","page":"Home","title":"AISCSteel.flexure_capacity_f5","text":"flexure_capacity_f5(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1, h, t_w, λ, λ_pf, λ_rf, f_class)\n\nCalculates the moment capacity of the applicable section.\n\nDescription of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. \n\nArguments\n\nE: elastic section modulous.\nG: shear modulous.\nF_y: yield strength of steel.\nZ_x: \nS_x:\nI_y:\nr_y:\nh_0:\nJ:\nC_w:\nc:\nr_ts:\nL_b:\nC_b:\nh:\nt_w:\nλ:\nλ_pf:\nλ_rf:\nf_class:\n\nReturns\n\nM_n: moment capacity of the section.\n\nReference\n\nAISC Section F5\n\n\n\n\n\n","category":"method"},{"location":"#AISCSteel.import_data-Tuple{Any, Symbol, String}","page":"Home","title":"AISCSteel.import_data","text":"import_data(lookup_value, lookup_col_name::Symbol, data_location::String)\n\nSearches the specified data location and filters for the first row of data found where the value in the column specified is equal to the lookup value.\n\nParameters\n\nlookup_value - The value to search for\nlookup_col_name::Symbol - the column name to search in\ncsv_file_path::String - The name of csv file in the data directory\n\n\n\n\n\n","category":"method"}]
}
