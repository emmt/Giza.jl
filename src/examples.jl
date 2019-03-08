module GizaExample
using Giza

function example1(devname::AbstractString="/xw",
                  prefix::AbstractString="Example 1")
    Giza.open_device(devname, prefix)
    Giza.set_environment(-10, 10, 0, 100, 0, 0)
    x = range(-10, stop=10, length=100);
    y = x.^2;
    Giza.line(x, y)
    Giza.annotate("B", 2.5, 0.5, 0.5, "Furlongs")
    Giza.annotate("L", 2.5, 0.5, 0.5, "Parsecs")
    Giza.close_device()
end

function example2(devname::AbstractString="/xw",
                  prefix::AbstractString="Example 2")
    Giza.open_device(devname, prefix)
    ls = Giza.get_line_style()
    lw = Giza.get_line_width()
    ci = Giza.get_colour_index()
    Giza.set_line_style(GIZA_LS_SOLID)
    Giza.set_line_width(1)
    Giza.set_colour_index(7)
    Giza.set_colour_representation(7, 1.0, 0.5, 0.0)
    Giza.set_environment(-10, 10, 0, 100, 0, 0)
    x = range(-10, stop=10, length=100);
    y = x.^2;
    Giza.line(x, y)
    Giza.annotate("B", 2.5, 0.5, 0.5, "Furlongs")
    Giza.annotate("L", 2.5, 0.5, 0.5, "Parsecs")
    Giza.set_line_style(ls)
    Giza.set_line_width(lw)
    Giza.set_colour_index(ci)
    #Giza.close_device()
end

function example3(devname::AbstractString="/xw",
                  prefix::AbstractString="Example 3")
    imgdim = 400
    windim = 640
    margin = (windim - imgdim)/2
    xmin = ymin = margin/imgdim
    xmax = ymax = (margin + imgdim)/imgdim

    Giza.open_device_size(devname, prefix, windim, windim, GIZA_UNITS_PIXELS)
    Giza.set_viewport(xmin, xmax, ymin, ymax)
    Giza.set_window(0, imgdim, 0, imgdim)
    Giza.set_box("BCTN", 0.0, 0, "BCNST", 0.0, 0)
end

function pli(img::AbstractMatrix{<:Real})
    devwidth, devheight = Giza.get_paper_size(Giza.GIZA_UNITS_PIXELS)
    imgwidth, imgheight = size(img)

    if imgwidth < devwidth && imgheight < devheight
        xmin = (devwidth - imgwidth)/2/devwidth
        xmax = xmin + imgwidth/devwidth
        ymin = (devheight - imgheight)/2/devheight
        ymax = ymin + imgheight/devheight
        Giza.stop_prompting()
        Giza.change_page()
        Giza.set_viewport(xmin, xmax, ymin, ymax)
        Giza.set_window(0, imgwidth, 0, imgheight)
        cimin, cimax = Giza.get_colour_index_range()
        amin, amax = extrema(img)
        if amin < amax && cimin < cimax
            a1 = (convert(Cdouble, cimax) - convert(Cdouble, cimin))
            a2 = (convert(Cdouble, amax) - convert(Cdouble, amin))
            a = a1/a2
            lvl = Array{Cint}(imgwidth, imgheight)
            @inbounds @simd for i in eachindex(lvl, img)
                lvl[i] = cimin + round(Cint, (img[i] - amin)*a)
            end
            Giza.draw_pixels(lvl, 0, imgwidth, 0, imgheight,
                             GIZA_EXTEND_NONE)
        end
    end
end

end # module
