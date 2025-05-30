module AISCsteelPrecompileTools

using PrecompileTools
using StructuralUnits
import AISCSteel
import AISCSteel.Shapes.IShapes.RolledIShapes as ris
import AISCSteel.Shapes.CShapes as cs
import AISCSteel.Shapes.LShapes as ls
import AISCSteel.Shapes.WTShapes as wts
import AISCSteel.Shapes.HSS_Shapes as hss
import AISCSteel.Shapes.RoundHSS_Shapes as rhss

@compile_workload begin
    # Precompile common shape creations
    w = ris.WShape("W14x90")
    c = cs.CShape("C15x33.9")
    lshape = ls.LShape("L5x3x1/2")
    wt = wts.WTShape("WT5x6")
    hss_shape = hss.HSS_Shape("HSS10x6x3/16")
    rhss_shape = rhss.RoundHSS_Shape("HSS20.000x0.500")
    
    # Precompile common flexure calculations with various unbraced lengths
    L_b_values = [0.0, 5.0, 10.0, 20.0] .* ft
    
    # WShape flexure
    for L_b in L_b_values
        ris.Flexure.calc_Mnx(w, L_b)
    end
    ris.Flexure.calc_Mny(w)
    
    # CShape flexure
    for L_b in L_b_values
        cs.Flexure.calc_Mnx(c, L_b)
    end
    cs.Flexure.calc_Mny(c)
    
    # LShape flexure
    L_b = 6ft
    C_b = 1.14
    restraint_types = [:fully_restrained, :unrestrained, :at_max_moment_only]
    
    for restraint_type in restraint_types
        ls.Flexure.calc_positive_Mnx(lshape, L_b, restraint_type, C_b)
        ls.Flexure.calc_positive_Mny(lshape, L_b, restraint_type, C_b)
        ls.Flexure.calc_negative_Mnx(lshape, L_b, restraint_type, C_b)
        ls.Flexure.calc_negative_Mny(lshape, L_b, restraint_type, C_b)
    end
    
    ls.Flexure.calc_positive_Mnz(lshape)
    ls.Flexure.calc_negative_Mnz(lshape)
    ls.Flexure.calc_positive_Mnw(lshape, L_b, C_b)
    ls.Flexure.calc_negative_Mnw(lshape, L_b, C_b)
    
    # WTShape flexure
    for L_b in L_b_values
        wts.Flexure.calc_positive_Mnx(wt, L_b)
        wts.Flexure.calc_negative_Mnx(wt, L_b)
    end
    
    # HSS_Shape flexure
    for L_b in L_b_values
        hss.Flexure.calc_Mnx(hss_shape, L_b, C_b)
    end
    hss.Flexure.calc_Mny(hss_shape)
    
    # RoundHSS_Shape flexure
    rhss.Flexure.calc_Mn(rhss_shape)
    
    # Precompile common compression calculations
    L_c_values = [0.0, 10.0, 15.0, 20.0] .* ft
    
    # WShape compression
    for L_c in L_c_values
        ris.Compression.calc_Pn(w, L_c, L_c)
    end
    
    # LShape compression
    leg_connecteds = [:long, :short]
    for L_c in L_c_values
        for leg_connected in leg_connecteds
            ls.Compression.calc_Pn(lshape, leg_connected, L_c)
            ls.Compression.calc_Pn(lshape, :type_b, leg_connected, L_c)
        end
    end
    
    # WTShape compression
    for L_c in L_c_values
        wts.Compression.calc_Pn(wt, L_c, L_c, L_c)
    end
    
    # HSS_Shape compression
    for L_c in L_c_values
        hss.Compression.calc_Pn(hss_shape, L_c, L_c)
    end
    
    # RoundHSS_Shape compression
    for L_c in L_c_values
        rhss.Compression.calc_Pn(rhss_shape, L_c, L_c)
    end
    
    # Precompile common classification functions
    ris.Flexure.classify_flange_major_axis(w)
    ris.Flexure.classify_flange_minor_axis(w)
    ris.Flexure.classify_web(w)
    ris.Flexure.classify_section(w)
    
    cs.Flexure.classify_flange_major_axis(c)
    cs.Flexure.classify_flange_minor_axis(c)
    cs.Flexure.classify_web(c)
    
    ls.Flexure.classify_leg(lshape)
    
    wts.Flexure.classify_flange(wt)
    
    hss.Flexure.classify_flange_major_axis(hss_shape)
    hss.Flexure.classify_flange_minor_axis(hss_shape)
    hss.Flexure.classify_web_major_axis(hss_shape)
    hss.Flexure.classify_web_minor_axis(hss_shape)
    
    rhss.Flexure.classify_round_hss(rhss_shape)
end

end # module