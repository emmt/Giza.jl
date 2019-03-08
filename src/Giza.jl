__precompile__(true)

module Giza

export
    GIZA_LS_SOLID,
    GIZA_LS_SHORT_DASH,
    GIZA_LS_DASHED,
    GIZA_LS_LONG_DASH,
    GIZA_LS_DOT,
    GIZA_LS_DOTTED,
    GIZA_LS_DASH_DOT,
    GIZA_LS_DASH_DOT_DOT_DOT,

    GIZA_NUMBER_FORMAT_AUTO,
    GIZA_NUMBER_FORMAT_DEC,
    GIZA_NUMBER_FORMAT_EXP,

    GIZA_UNITS_NORMALISED,
    GIZA_UNITS_INCHES,
    GIZA_UNITS_MM,
    GIZA_UNITS_PIXELS,
    GIZA_UNITS_WORLD,
    GIZA_UNITS_DEVICE,

    GIZA_BACKGROUND,
    GIZA_BACKGROUND_COLOUR,
    GIZA_BACKGROUND_COLOR,
    GIZA_FOREGROUND,
    GIZA_FOREGROUND_COLOUR,
    GIZA_FOREGROUND_COLOR,

    GIZA_COLOUR_INDEX_MIN,
    GIZA_COLOUR_INDEX_MAX,

    GIZA_COLOUR_PALETTE_DEFAULT,
    GIZA_COLOR_PALETTE_DEFAULT,
    GIZA_COLOUR_PALETTE_PGPLOT,
    GIZA_COLOR_PALETTE_PGPLOT,

    GIZA_FILL_SOLID,
    GIZA_FILL_HOLLOW,
    GIZA_FILL_HATCH,
    GIZA_FILL_CROSSHATCH,

    GIZA_MAX_FILL_STYLES,

    GIZA_EXTEND_NONE,
    GIZA_EXTEND_REPEAT,
    GIZA_EXTEND_REFLECT,
    GIZA_EXTEND_PAD,

    GIZA_BAND_NONE,
    GIZA_BAND_LINE,
    GIZA_BAND_RECTANGLE,
    GIZA_BAND_HORZLINES,
    GIZA_BAND_VERTLINES,
    GIZA_BAND_HORZLINE,
    GIZA_BAND_VERTLINE,
    GIZA_BAND_CROSSHAIR,
    GIZA_BAND_CIRCLE,

    GIZA_LEFT_CLICK,
    GIZA_MIDDLE_CLICK,
    GIZA_RIGHT_CLICK,
    GIZA_SHIFT_CLICK,
    GIZA_SCROLL_UP,
    GIZA_SCROLL_DOWN,
    GIZA_SCROLL_LEFT,
    GIZA_SCROLL_RIGHT,
    GIZA_OTHER_CLICK

if isfile(joinpath(@__DIR__, "..", "deps", "deps.jl"))
    include(joinpath("..", "deps", "deps.jl"))
else
    if false
        # For official package.
        error("Giza not properly installed.  Please run Pkg.build(\"Giza\")")
    else
        # For un-official package.
        error(string("Giza not properly installed.  Please run:\n\n",
                     "    cd \"", normpath(@__DIR__, "..", "deps"), "\"\n",
                     "    make GIZA_JL_DLL=\"\$PATH_TO_GIZA_DLL\"\n"))
    end
end

_array(::Type{T}, A::DenseArray{T,N}) where {T<:Real,N} = A
_array(::Type{T}, A::AbstractArray{<:Real,N}) where {T<:Real,N} =
    convert(Array{T,N}, A)

_float(::Type{Cfloat}) = Cfloat
_float(::Type{<:Real}) = Cdouble
_float(::Type{Cfloat}, ::Type{Cfloat}) = Cfloat
_float(::Type{<:Real}, ::Type{<:Real}) = Cdouble
_float(::Type{Cfloat}, ::Type{Cfloat}, ::Type{Cfloat}) = Cfloat
_float(::Type{<:Real}, ::Type{<:Real}, ::Type{<:Real}) = Cdouble

const GIZA_LS_SOLID            = Cint(1)
const GIZA_LS_SHORT_DASH       = Cint(2)
const GIZA_LS_DASHED           = Cint(2)
const GIZA_LS_LONG_DASH        = Cint(3)
const GIZA_LS_DOT              = Cint(4)
const GIZA_LS_DOTTED           = Cint(4)
const GIZA_LS_DASH_DOT         = Cint(5)
const GIZA_LS_DASH_DOT_DOT_DOT = Cint(6)

const GIZA_NUMBER_FORMAT_AUTO  = Cint(0)
const GIZA_NUMBER_FORMAT_DEC   = Cint(1)
const GIZA_NUMBER_FORMAT_EXP   = Cint(2)

const GIZA_UNITS_NORMALISED = Cint(0)
const GIZA_UNITS_INCHES     = Cint(1)
const GIZA_UNITS_MM         = Cint(2)
const GIZA_UNITS_PIXELS     = Cint(3)
const GIZA_UNITS_WORLD      = Cint(4)
const GIZA_UNITS_DEVICE     = Cint(5)

const GIZA_BACKGROUND        = Cint(0)
const GIZA_BACKGROUND_COLOUR = GIZA_BACKGROUND
const GIZA_BACKGROUND_COLOR  = GIZA_BACKGROUND
const GIZA_FOREGROUND        = Cint(1)
const GIZA_FOREGROUND_COLOUR = GIZA_FOREGROUND
const GIZA_FOREGROUND_COLOR  = GIZA_FOREGROUND

const GIZA_COLOUR_INDEX_MIN  =   0
const GIZA_COLOUR_INDEX_MAX  = 271

const GIZA_COLOUR_PALETTE_DEFAULT = Cint(0)
const GIZA_COLOR_PALETTE_DEFAULT  = GIZA_COLOUR_PALETTE_DEFAULT
const GIZA_COLOUR_PALETTE_PGPLOT  = Cint(1)
const GIZA_COLOR_PALETTE_PGPLOT   = GIZA_COLOUR_PALETTE_PGPLOT

const GIZA_FILL_SOLID      = Cint(1)
const GIZA_FILL_HOLLOW     = Cint(2)
const GIZA_FILL_HATCH      = Cint(3)
const GIZA_FILL_CROSSHATCH = Cint(4)

const GIZA_MAX_FILL_STYLES = 4

const GIZA_EXTEND_NONE    = Cint(0)
const GIZA_EXTEND_REPEAT  = Cint(1)
const GIZA_EXTEND_REFLECT = Cint(2)
const GIZA_EXTEND_PAD     = Cint(3)

function arrow(x1::Real, y1::Real, x2::Real, y2::Real)
    ccall((:giza_arrow, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble),
          x1, y1, x2, y2)
end

function set_arrow_style(fillstyle::Integer, angle::Real, cutback::Real)
     ccall((:giza_set_arrow_style, _GIZALIB), Cvoid,
           (Cint, Cdouble, Cdouble),
           fillstyle, angle, cutback)
end

function get_arrow_style()
    fillstyle = Ref{Cint}()
    angle = Ref{Cdouble}()
    fillstyle = Ref{Cdouble}()
     ccall((:giza_get_arrow_style, _GIZALIB), Cvoid,
           (Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}),
           fillstyle, angle, cutback)
    return (fillstyle[], angle[], cutback[])
end

function annotate(side::AbstractString,
                  offset::Real,
                  coord::Real,
                  just::Real,
                  text::AbstractString)
    ccall((:giza_annotate, _GIZALIB), Cvoid,
          (Cstring, Cdouble, Cdouble, Cdouble, Cstring),
          side, offset, coord, just, text)
end

function label(xlab::AbstractString,
               ylab::AbstractString,
               title::AbstractString)
    ccall((:giza_label, _GIZALIB), Cvoid,
          (Cstring, Cstring, Cstring),
          xlab, ylab, title)
end

const GIZA_BAND_NONE      = Cint(0)
const GIZA_BAND_LINE      = Cint(1)
const GIZA_BAND_RECTANGLE = Cint(2)
const GIZA_BAND_HORZLINES = Cint(3)
const GIZA_BAND_VERTLINES = Cint(4)
const GIZA_BAND_HORZLINE  = Cint(5)
const GIZA_BAND_VERTLINE  = Cint(6)
const GIZA_BAND_CROSSHAIR = Cint(7)
const GIZA_BAND_CIRCLE    = Cint(8)

const GIZA_LEFT_CLICK     = 'A'
const GIZA_MIDDLE_CLICK   = 'D'
const GIZA_RIGHT_CLICK    = 'X'
const GIZA_SHIFT_CLICK    = Char(15)
const GIZA_SCROLL_UP      = Char(21)
const GIZA_SCROLL_DOWN    = Char( 4)
const GIZA_SCROLL_LEFT    = Char(12)
const GIZA_SCROLL_RIGHT   = Char(18)
const GIZA_OTHER_CLICK    = 'X'

function band(mode::Integer, move::Bool, xanc::Real, yanc::Real)
    x = Ref{Cdouble}()
    y = Ref{Cdouble}()
    c = Ref{Cchar}()
    code = ccall((:giza_band, _GIZALIB), Cint,
                 (Cint, Cint, Cdouble, Cdouble,
                  Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cchar}),
                 mode, move, xanc, yanc, x, y, c)
    if code != 0
        error("giza_band failed with error $code")
    end
    return (x[], y[], Char(c[]))
end

function get_band_style()
    ls = Ref{Cint}()
    lw = Ref{Cdouble}()
    ccall((:giza_get_band_style, _GIZALIB), Cvoid,
          (Ptr{Cint}, Ptr{Cdouble}), ls, lw)
    return (ls[], lw[])
end

function set_band_style(ls::Integer, lw::Real)
    ccall((:giza_set_band_style, _GIZALIB), Cvoid,
          (Cint, Cdouble), ls, lw)
end

for f in (:box, :box_time)
    @eval function $f(xopt::AbstractString, xtick::Real, nxsub::Integer,
	              yopt::AbstractString, ytick::Real, nysub::Integer)
        ccall(($(string("giza_",f)), _GIZALIB), Cvoid,
              (Cstring, Cdouble, Cint, Cstring, Cdouble, Cint),
              xopt, xtick, nxsub, yopt, ytick, nysub)
    end
end

function get_buffering()
    buf = Ref{Cint}()
    ccall((:giza_get_buffering, _GIZALIB), Cvoid, (Ptr{Cint},), buf)
    return (buf[] != 0)
end

function circle(x::Real, y::Real, r::Real)
    ccall((:giza_circle, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble),
          x, y, r)
end

set_character_height(h::Real) =
    ccall((:giza_set_character_height, _GIZALIB), Cvoid, (Cdouble,), h)

function get_character_height()
    h = Ref{Cdouble}()
    ccall((:giza_get_character_height, _GIZALIB), Cvoid,
          (Ptr{Cdouble},), h)
    return h[]
end

function get_character_size(units::Integer)
    x = Ref{Cdouble}()
    y = Ref{Cdouble}()
    ccall((:giza_get_character_size, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}), units, x, y)
    return (x[], y[])
end

function set_clipping(clip::Bool)
    ccall((:giza_set_clipping, _GIZALIB), Cvoid, (Cint,), clip)
end

function get_clipping()
    clip = Ref{Cint}()
    ccall((:giza_get_clipping, _GIZALIB), Cvoid, (Ptr{Cint},), clip)
    return (clip[] != 0)
end

color_bar(args...) = set_colour_bar(args...)

function colour_bar(side::AbstractString, disp::Real, width::Real,
                    vmin::Real, vmax::Real, label::AbstractString)
    ccall((:giza_colour_bar, _GIZALIB), Cvoid,
          (Cstring, Cdouble, Cdouble, Cdouble, Cdouble, Cstring),
          side, disp, width, vmin, vmax, label)
end

function set_colour_index(ci::Integer)
    ccall((:giza_set_colour_index, _GIZALIB), Cvoid, (Cint,), ci)
end

function get_colour_index()
    ci = Ref{Cint}()
    ccall((:giza_get_colour_index, _GIZALIB), Cvoid, (Ptr{Cint},), ci)
    return ci[]
end

function set_colour_index_range(cimin::Integer, cimax::Integer)
    ccall((:giza_set_colour_index_range, _GIZALIB), Cvoid,
          (Cint, Cint), cimin, cimax)
end

function get_colour_index_range()
    cimin = Ref{Cint}()
    cimax = Ref{Cint}()
    ccall((:giza_get_colour_index_range, _GIZALIB), Cvoid,
          (Ptr{Cint}, Ptr{Cint}), cimin, cimax)
    return (cimin[], cimax[])
end

function set_colour_palette(pal::Integer)
    ccall((:giza_set_colour_palette, _GIZALIB), Cvoid, (Cint,), pal)
end

function set_colour_representation(ci::Integer,
                                   red::Real,
                                   green::Real,
                                   blue::Real)
    ccall((:giza_set_colour_representation, _GIZALIB), Cvoid,
          (Cint, Cdouble, Cdouble, Cdouble), ci, red, green, blue)
end

function get_colour_representation(ci::Integer)
    red   = Ref{Cdouble}()
    green = Ref{Cdouble}()
    blue  = Ref{Cdouble}()
    ccall((:giza_get_colour_representation, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          ci, red, green, blue)
    return (red[], green[], blue[])
end

function set_colour_representation_alpha(ci::Integer,
                                         red::Real,
                                         green::Real,
                                         blue::Real,
                                         alpha::Real)
    ccall((:giza_set_colour_representation_alpha, _GIZALIB), Cvoid,
          (Cint, Cdouble, Cdouble, Cdouble, Cdouble),
          ci, red, green, blue, alpha)
end

function get_colour_representation_alpha(ci::Integer)
    red   = Ref{Cdouble}()
    green = Ref{Cdouble}()
    blue  = Ref{Cdouble}()
    alpha = Ref{Cdouble}()
    ccall((:giza_get_colour_representation_alpha, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          ci, red, green, blue, alpha)
    return (red[], green[], blue[], alpha[])
end

function set_colour_representation_rgb(ci::Integer,
                                       red::Integer,
                                       green::Integer,
                                       blue::Integer)
    ccall((:giza_set_colour_representation_rgb, _GIZALIB), Cvoid,
          (Cint, Cint, Cint, Cint), ci, red, green, blue)
end

function get_colour_representation_rgb(ci::Integer)
    red   = Ref{Cint}()
    green = Ref{Cint}()
    blue  = Ref{Cint}()
   ccall((:giza_get_colour_representation_rgb, _GIZALIB), Cvoid,
          (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}),
          ci, red, green, blue)
    return (red[], green[], blue[])
end

function set_colour_representation_rgba(ci::Integer,
                                        red::Integer,
                                        green::Integer,
                                        blue::Integer,
                                        alpha::Real)
    ccall((:giza_set_colour_representation_rgba, _GIZALIB), Cvoid,
          (Cint, Cint, Cint, Cint, Cdouble), ci, red, green, blue, alpha)
end

function get_colour_representation_rgba(ci::Integer)
    red   = Ref{Cint}()
    green = Ref{Cint}()
    blue  = Ref{Cint}()
    alpha = Ref{Cdouble}()
    ccall((:giza_get_colour_representation_rgba, _GIZALIB), Cvoid,
          (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}),
          ci, red, green, blue, alpha)
    return (red[], green[], blue[], alpha[])
end

function set_colour_representation_hls(ci::Integer,
                                       hue::Real,
                                       lightness::Real,
                                       saturation::Real)
    ccall((:giza_set_colour_representation_hls, _GIZALIB), Cvoid,
          (Cint, Cdouble, Cdouble, Cdouble),
          ci, hue, lightness, saturation)
end

function set_colour_table(pos::AbstractVector{<:Real},
                          red::AbstractVector{<:Real},
                          green::AbstractVector{<:Real},
                          blue::AbstractVector{<:Real},
                          contrast::Real,
                          brightness::Real)
    n = length(pos)
    @assert length(red) == n
    @assert length(green) == n
    @assert length(blue) == n
    code = ccall((:giza_set_colour_table, _GIZALIB), Cint,
                 (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble},
                  Cint, Cdouble, Cdouble),
                 _array(Cdouble, pos), _array(Cdouble, red),
                 _array(Cdouble, green), _array(Cdouble, blue),
                 n, contrast, brightness)
    if code != 0
        error("giza_set_colour_table failed with error $code")
    end
end

function set_colour_table_gray()
    code = ccall((:giza_set_colour_table_gray, _GIZALIB), Cint, ())
    if code != 0
        error("giza_set_colour_table_gray failed with error $code")
    end
end

function rgb_from_table(pos::Real)
    red   = Ref{Cdouble}()
    green = Ref{Cdouble}()
    blue  = Ref{Cdouble}()
    ccall((:giza_rgb_from_table, _GIZALIB), Cvoid,
          (Cdouble, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          pos, red, green, blue)
    return (red[], green[], blue[])
end

function contour(arr::AbstractMatrix{<:Real},
                 cont::AbstractVector{<:Real},
                 aff::AbstractArray{<:Real,N}) where {N}
    @assert length(aff) == 6
    xdim, ydim = size(arr)
    ccall((:giza_contour, _GIZALIB), Cvoid,
          (Cint, Cint, Ptr{Cdouble}, Cint, Cint, Cint, Cint, Cint,
	   Ptr{Cdouble}, Ptr{Cdouble}),
          xdim, ydim, _array(Cdouble, arr), 0, xdim - 1, 0, ydim - 1,
          length(cont), _array(Cdouble, cont), _array(Cdouble, affine))
end

function get_current_point()
    x = Ref{Cdouble}()
    y = Ref{Cdouble}()
    ccall((:giza_get_current_point, _GIZALIB), Cvoid,
          (Ptr{Cdouble}, Ptr{Cdouble}), x, y)
    return (x[], y[])
end

function open_device(devname::AbstractString, prefix::AbstractString)
    id = ccall((:giza_open_device, _GIZALIB), Cint,
               (Cstring, Cstring), devname, prefix)
    if id <= 0
        error("giza_open_device failed")
    end
    return id
end

function open_device_size(devname::AbstractString, prefix::AbstractString,
                          width::Real, height::Real, units::Integer)
    code = ccall((:giza_open_device_size, _GIZALIB), Cint,
          (Cstring, Cstring, Cdouble, Cdouble, Cint),
          devname, prefix, width, height, units)
    if code != 0
        error("giza_open_device falied with error $code")
    end
end

function select_device(dev::Integer)
    ccall((:giza_select_device, _GIZALIB), Cvoid, (Cint,), dev)
end

function get_device_id()
    dev = Ref{Cint}()
    ccall((:giza_get_device_id, _GIZALIB), Cvoid, (Ptr{Cint},), dev)
    return dev[]
end

function query_device(key::AbstractString)
    buf = Array{UInt8}(undef, 3000) # FIXME: the function below is badly coded
    ccall((:giza_query_device, _GIZALIB), Cint,
          (Cstring, Ptr{UInt8}), key, buf)
    buf[end] = 0
    return unsafe_string(pointer(buf))
end

function device_has_cursor()
    return (ccall((:giza_device_has_cursor, _GIZALIB), Cint, ()) != 0)
end

function get_key_press()
    x = Ref{Cdouble}()
    y = Ref{Cdouble}()
    c = Ref{Cchar}()
    code = ccall((:giza_get_key_press, _GIZALIB), Cint,
                 (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cchar}),
                 x, y, c)
    if code != 0
        error("giza_get_key_press failed with error $code")
    end
    return (x[], y[], Char(c[]))
end

function draw(x::Real, y::Real)
    ccall((:giza_draw, _GIZALIB), Cvoid,
          (Cdouble, Cdouble), x, y)
end

function set_environment(xmin::Real, xmax::Real,
                         ymin::Real, ymax::Real,
                         just::Integer, axis::Integer)
    ccall((:giza_set_environment, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble, Cint, Cint),
          xmin, xmax, ymin, ymax, just, axis)
end

function error_bars(dir::Integer,
                    xpts::AbstractVector{Tx},
                    ypts::AbstractVector{Ty},
                    errs::AbstractVector{Te},
                    term::Real) where {Tx<:Real, Ty<:Real, Te<:Real}
    @assert length(xpts) == length(ypts) == length(errs)
    n = length(xpts)
    T = _float(Tx, Ty, Te)
    _error_bars(dir, n,
                _array(T, xpts),
                _array(T, ypts),
                _array(T, errs), term)
end

function _error_bars(dir::Integer,
                     n::Integer,
                     xpts::DenseVector{Cdouble},
                     ypts::DenseVector{Cdouble},
                     errs::DenseVector{Cdouble},
                     term::Real)
    ccall((:giza_error_bars, _GIZALIB), Cvoid,
          (Cint, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cdouble),
          dir, n, xpts, ypts, errs, term)
end

function _error_bars(dir::Integer,
                     n::Integer,
                     xpts::DenseVector{Cfloat},
                     ypts::DenseVector{Cfloat},
                     errs::DenseVector{Cfloat},
                     term::Cfloat)
    ccall((:giza_error_bars_float, _GIZALIB), Cvoid,
          (Cint, Cint, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}, Cfloat),
          dir, n, xpts, ypts, errs, term)
end

function error_bars_vert(dir::Integer,
                         xpts::AbstractVector{Tx},
                         ypts1::AbstractVector{Ty1},
                         ypts2::AbstractVector{Ty2},
                         term::Real) where {Tx<:Real, Ty1<:Real, Ty2<:Real}
    @assert length(xpts) == length(ypts1) == length(ypts2)
    n = length(xpts)
    T = _float(Tx, Ty1, Ty2)
    _error_bars_vert(dir, n,
                     _array(T, xpts),
                     _array(T, ypts1),
                     _array(T, ypts2), term)
end

function _error_bars_vert(n::Integer,
                          xpts::DenseVector{Cdouble},
                          ypts1::DenseVector{Cdouble},
                          ypts2::DenseVector{Cdouble},
                          term::Real)
    ccall((:giza_error_bars_vert, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cdouble),
          n, xpts, ypts1, ypts2, term)
end

function _error_bars_vert(n::Integer,
                          xpts::DenseVector{Cfloat},
                          ypts1::DenseVector{Cfloat},
                          ypts2::DenseVector{Cfloat},
                          term::Cfloat)
    ccall((:giza_error_bars_vert_float, _GIZALIB), Cvoid,
          (Cint, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}, Cfloat),
          n, xpts, ypts1, ypts2, term)
end

function error_bars_hori(dir::Integer,
                         xpts1::AbstractVector{Tx1},
                         xpts2::AbstractVector{Tx2},
                         ypts::AbstractVector{Ty},
                         term::Real) where {Tx1<:Real, Tx2<:Real, Ty<:Real}
    @assert length(xpts1) == length(xpts2) == length(ypts)
    n = length(xpts)
    T = _float(Tx1, Tx2, Ty)
    _error_bars_hori(dir, n,
                     _array(T, xpts1),
                     _array(T, xpts2),
                     _array(T, ypts), term)
end

function _error_bars_hori(n::Integer,
                          xpts1::DenseVector{Cdouble},
                          xpts2::DenseVector{Cdouble},
                          ypts::DenseVector{Cdouble},
                          term::Real)
    ccall((:giza_error_bars_hori, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cdouble),
          n, xpts1, xpts2, ypts, term)
end

function _error_bars_hori(n::Integer,
                          xpts1::DenseVector{Cfloat},
                          xpts2::DenseVector{Cfloat},
                          ypts::DenseVector{Cfloat},
                          term::Cfloat)
    ccall((:giza_error_bars_hori_float, _GIZALIB), Cvoid,
          (Cint, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}, Cfloat),
          n, xpts1, xpts2, ypts, term)
end

function set_fill(fs::Integer)
    ccall((:giza_set_fill, _GIZALIB), Cvoid, (Cint,), fs)
end

function get_fill()
    fs = Ref{Cint}()
    ccall((:giza_get_fill, _GIZALIB), Cvoid, (Ptr{Cint},), fs)
    return fs[]
end

function format_number(mantissa::Integer, power::Integer, form::Integer)
    buf = Array{UInt8}(undef, 102)
    ccall((:giza_format_number, _GIZALIB), Cvoid,
          (Cint, Cint, Cint, Ptr{UInt8}),
          mantissa, power, form, buf)
    buf[end] = 0
    return unsafe_string(pointer(buf))
end

# FIXME: Implement bindings for these?
# void giza_function_x(double (*func) (double *x), int n, double xmin,
#                     double xmax, int flag);
# void giza_function_x_float(float (*func) (float *x), int n,
#                            float xmin, float xmax, int flag);
# void giza_function_y(double (*func) (double *y), int n, double ymin,
#                      double ymax, int flag);
# void giza_function_y_float(float (*func) (float *y), int n,
#                            float ymin, float ymax, int flag);
# void giza_function_t(double (*funcx) (double *t),
#                      double (*funcy) (double *t), int n, double ymin,
#                      double ymax, int flag);
# void giza_function_t_float(float (*funcx) (float *t),
#                            float (*funcy) (float *t), int n,
#                            float ymin, float ymax, int flag);

function get_surface_size()
    x1 = Ref{Cdouble}()
    x2 = Ref{Cdouble}()
    y1 = Ref{Cdouble}()
    y2 = Ref{Cdouble}()
    ccall((:giza_get_surface_size, _GIZALIB), Cvoid,
          (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          x1, x2, y1, y2)
    return (x1[], x2[], y1[], y2[])
end

function set_hatching_style(angle::Real, spacing::Real, phase::Real)
    ccall((:giza_set_hatching_style, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble),
          angle, spacing, phase)
end

function get_hatching_style()
    angle   = Ref{Cdouble}()
    spacing = Ref{Cdouble}()
    phase   = Ref{Cdouble}()
    ccall((:giza_get_hatching_style, _GIZALIB), Cvoid,
          (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          angle, spacing, phase)
    return (angle[], spacing[], phase[])
end

function histogram(dat::AbstractArray{<:Real},
                   vmin::Real, vmax::Real,
                   nbin::Integer, flag::Integer)
    n = length(dat)
    ccall((:giza_histogram, _GIZALIB), Cvoid,
           (Cint, Ptr{Cdouble}, Cdouble, Cdouble, Cint, Cint),
          n, _array(Cdouble, dat), vmin, vmax, nbin, flag)
end

function histogram_binned(x::AbstractVector{<:Real},
                          y::AbstractVector{<:Real},
                          center::Bool)
    @assert length(x) == length(y)
    n = length(x)
    ccall((:giza_histogram_binned, _GIZALIB), Cvoid,
           (Cint, Ptr{Cdouble}, Ptr{Cdouble}, Cint),
          n, _array(Cdouble, x), _array(Cdouble, y), center)
end

function line(xpts::AbstractVector{Tx},
              ypts::AbstractVector{Ty}) where {Tx<:Real, Ty<:Real}
    @assert length(xpts) == length(xpts)
    T = _float(Tx, Ty)
    n = length(xpts)
    _line(n, _array(T, xpts), _array(T, ypts))
end

_line(n::Integer, xpts::DenseVector{Cdouble}, ypts::DenseVector{Cdouble}) =
    ccall((:giza_line, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}), n, xpts, ypts)

_line(n::Integer, xpts::DenseVector{Cfloat}, ypts::DenseVector{Cfloat}) =
    ccall((:giza_line_float, _GIZALIB), Cvoid,
          (Cint, Ptr{Cfloat}, Ptr{Cfloat}), n, xpts, ypts)

function set_line_style(ls::Integer)
    ccall((:giza_set_line_style, _GIZALIB), Cvoid, (Cint,), ls)
end

function get_line_style()
    ls = Ref{Cint}()
    ccall((:giza_get_line_style, _GIZALIB), Cvoid, (Ptr{Cint},), ls)
    return ls[]
end

function set_line_width(lw::Real)
    ccall((:giza_set_line_width, _GIZALIB), Cvoid, (Cdouble,), lw)
end

function get_line_width()
    lw = Ref{Cdouble}()
    ccall((:giza_get_line_width, _GIZALIB), Cvoid, (Ptr{Cdouble},), lw)
    return lw[]
end

function set_line_cap(lc::Integer)
    ccall((:giza_set_line_cap, _GIZALIB), Cvoid, (Cint,), lc)
end

function get_line_cap()
    lc = Ref{Cint}()
    ccall((:giza_get_line_cap, _GIZALIB), Cvoid, (Ptr{Cint},), lc)
    return lc[]
end

for f in (:mark_line, :mark_line_ordered)
    @eval begin
        function $f(maxpts::Integer)
            @assert maxpts ≥ 1
            xpts = Array{Cdouble}(undef, maxpts)
            ypts = Array{Cdouble}(undef, maxpts)
            npts = Ref{Cint}(0)
            ccall(($(string("giza_",f)), _GIZALIB), Cvoid,
                  (Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}),
                  maxpts, npts, xpts, ypts)
            if npts[] < maxpts
                resize!(xpts, npts[])
                resize!(ypts, npts[])
            end
            return (xpts, ypts)
        end

        function $f(maxpts::Integer, xanc::Real, yanc::Real)
            @assert maxpts ≥ 1
            xpts = Array{Cdouble}(undef, maxpts)
            ypts = Array{Cdouble}(undef, maxpts)
            npts = Ref{Cint}(1)
            xpts[1] = xanc
            ypts[1] = yanc
            ccall(($(string("giza_",f)), _GIZALIB), Cvoid,
                  (Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}),
                  maxpts, npts, xpts, ypts)
            if npts[] < maxpts
                resize!(xpts, npts[])
                resize!(ypts, npts[])
            end
            return (xpts, ypts)
        end
    end
end

for f in (:mark_points, :mark_points_ordered)
    @eval begin
        function $f(maxpts::Integer, sym::Integer)
            @assert maxpts ≥ 1
            xpts = Array{Cdouble}(undef, maxpts)
            ypts = Array{Cdouble}(undef, maxpts)
            npts = Ref{Cint}(0)
            ccall(($(string("giza_",f)), _GIZALIB), Cvoid,
                  (Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Cint),
                  maxpts, npts, xpts, ypts, sym)
            if npts[] < maxpts
                resize!(xpts, npts[])
                resize!(ypts, npts[])
            end
            return (xpts, ypts)
        end

        function $f(maxpts::Integer, sym::Integer, xanc::Real, yanc::Real)
            @assert maxpts ≥ 1
            xpts = Array{Cdouble}(undef, maxpts)
            ypts = Array{Cdouble}(undef, maxpts)
            npts = Ref{Cint}(1)
            xpts[1] = xanc
            ypts[1] = yanc
            ccall(($(string("giza_",f)), _GIZALIB), Cvoid,
                  (Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Cint),
                  maxpts, npts, xpts, ypts, sym)
            if npts[] < maxpts
                resize!(xpts, npts[])
                resize!(ypts, npts[])
            end
            return (xpts, ypts)
        end
    end
end

function move(x::Real, y::Real)
    ccall((:giza_move, _GIZALIB), Cvoid,
          (Cdouble, Cdouble), x, y)
end

function set_paper_size(units::Integer, width::Real, height::Real)
    ccall((:giza_set_paper_size, _GIZALIB), Cvoid,
          (Cint, Cdouble, Cdouble),
          units, width, height)
end

function get_paper_size(units::Integer)
    width  = Ref{Cdouble}()
    height = Ref{Cdouble}()
    ccall((:giza_get_paper_size, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}),
          units, width, height)
    return (width[], height[])
end

function points(xpts::AbstractVector{Tx},
                ypts::AbstractVector{Ty},
                sym::Integer) where {Tx<:Real, Ty<:Real}
    @assert length(xpts) == length(ypts)
    T = _float(Tx, Ty)
    n = length(xpts)
    _points(n, _array(T, xpts), _array(T, ypts), sym)
end

function _points(n::Integer,
                 xpts::DenseVector{Cdouble},
                 ypts::DenseVector{Cdouble},
                 sym::Integer)
    ccall((:giza_points, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}, Cint),
          n, xpts, ypts, sym)
end

function _points(n::Integer,
                 xpts::DenseVector{Cfloat},
                 ypts::DenseVector{Cfloat},
                 sym::Integer)
    ccall((:giza_points_float, _GIZALIB), Cvoid,
          (Cint, Ptr{Cfloat}, Ptr{Cfloat}, Cint),
          n, xpts, ypts, sym)
end

function single_point(x::Real, y::Real, sym::Integer)
    ccall((:giza_single_point, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cint),
          x, y, sym)
end

function polygon(xpts::AbstractVector{Tx},
                 ypts::AbstractVector{Ty}) where {Tx<:Real, Ty<:Real}
    @assert length(xpts) == length(ypts)
    T = _float(Tx, Ty)
    n = length(xpts)
    _polygon(n, _array(T, xpts), _array(T, ypts))
end

function _polygon(n::Integer,
                  xpts::DenseVector{Cdouble},
                  ypts::DenseVector{Cdouble})
    ccall((:giza_polygon, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}),
          n, xpts, ypts)
end

function _polygon(n::Integer,
                  xpts::DenseVector{Cfloat},
                  ypts::DenseVector{Cfloat})
    ccall((:giza_polygon_float, _GIZALIB), Cvoid,
          (Cint, Ptr{Cfloat}, Ptr{Cfloat}),
          n, xpts, ypts)
end

function text(x::Real, y::Real, text::AbstractString)
    ccall((:giza_text, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cstring),
          x, y, text)
end

function ptext(x::Real, y::Real, angle::Real, just::Real, text::AbstractString)
    ccall((:giza_ptext, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble, Cstring),
          x, y, angle, just, text)
end

function qtext(x::Real, y::Real, angle::Real, just::Real, text::AbstractString)
    xbox = Ref{NTuple{4,Cdouble}}()
    ybox = Ref{NTuple{4,Cdouble}}()
    ccall((:giza_qtext, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble, Cstring,
           Ptr{Cdouble}, Ptr{Cdouble}),
          x, y, angle, just, text, xbox, ybox)
    return (xbox[], ybox[])
end

function qtextlen(units::Integer, text::AbstractString)
    xlen = Ref{Cdouble}()
    ylen = Ref{Cdouble}()
    ccall((:giza_qtextlen, _GIZALIB), Cvoid,
          (Cint, Cstring, Ptr{Cdouble}, Ptr{Cdouble}),
          units, text, xlen, ylen)
    return (xlen[], ylen[])
end

function rectangle(x1::Real, x2::Real, y1::Real, y2::Real)
    ccall((:giza_rectangle, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble),
          x1, x2, y1, y2)
end

function rectangle_rounded(x1::Real, x2::Real, y1::Real, y2::Real, r::Real)
    ccall((:giza_rectangle_rounded, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble, Cdouble),
          x1, x2, y1, y2, r)
end

for f in (:begin_autolog,
          :begin_buffer,
          :change_page,
          :close_device,
          :draw_background,
          :end_autolog,
          :end_buffer,
          :flush_buffer,
          :flush_device,
          :print_device_list,
          :print_id,
          :restore,
          :restore_colour_table,
          :save,
          :save_colour_table,
          :set_viewport_default,
          :start_prompting,
          :start_warnings,
          :stop_prompting,
          :stop_warnings)
    @eval $f() =
        ccall(($(string("giza_",f)), _GIZALIB), Cvoid, ())
end

for f in (:render, :render_transparent, :render_gray)
    _f = Symbol(:_,f)
    @eval begin
        function $f(arr::AbstractMatrix{Tarr},
                    vmin::Real,
                    vmax::Real,
                    extend::Integer,
                    aff::AbstractArray{Taff,N}) where {Tarr<:Real,
                                                       Taff<:Real, N}
            @assert length(aff) == 6
            T = _float(Tarr, Taff)
            xdim, ydim = size(arr)
            $_f(xdim, ydim, _array(T, arr), 0, xdim - 1, 0, ydim - 1,
                convert(T, vmin), convert(T, vmax), extend,
                _array(T, aff))
        end

        function $_f(xdim::Integer,
                     ydim::Integer,
                     arr::DenseMatrix{Cdouble},
                     i1::Integer,
                     i2::Integer,
                     j1::Integer,
                     j2::Integer,
                     vmin::Cdouble,
                     vmax::Cdouble,
                     extend::Integer,
                     aff::DenseArray{Cdouble,N}) where {N}
            ccall(($(string("giza_",f)), _GIZALIB), Cvoid,
                  (Cint, Cint, Ptr{Cdouble}, Cint, Cint, Cint, Cint,
                   Cdouble, Cdouble, Cint, Ptr{Cdouble}),
                  xdim, ydim, arr, i1, i2, j1, j2, vmin, vmax, extend, aff)
        end

        function $_f(xdim::Integer,
                     ydim::Integer,
                     arr::DenseMatrix{Cfloat},
                     i1::Integer,
                     i2::Integer,
                     j1::Integer,
                     j2::Integer,
                     vmin::Cfloat,
                     vmax::Cfloat,
                     extend::Integer,
                     aff::DenseArray{Cfloat,N}) where {N}
            ccall(($(string("giza_",f,"_float")), _GIZALIB), Cvoid,
                  (Cint, Cint, Ptr{Cfloat}, Cint, Cint, Cint, Cint,
                   Cfloat, Cfloat, Cint, Ptr{Cfloat}),
                  xdim, ydim, arr, i1, i2, j1, j2, vmin, vmax, extend, aff)
        end

    end
end

function render_alpha(arr::AbstractMatrix{Tarr},
                      alpha::AbstractMatrix{Talpha},
                      vmin::Real,
                      vmax::Real,
                      extend::Integer,
                      aff::AbstractArray{Taff,N}) where {Tarr<:Real,
                                                         Talpha<:Real,
                                                         Taff<:Real, N}
    @assert size(arr) == size(alpha)
    @assert length(aff) == 6
    T = _float(Tarr, Talpha, Taff)
    xdim, ydim = size(arr)
    _render_alpha(xdim, ydim, _array(T, arr),  _array(T, alpha),
                  0, xdim - 1, 0, ydim - 1,
                  convert(T, vmin), convert(T, vmax),
                  extend, _array(T, aff))
end

function _render_alpha(xdim::Integer,
                       ydim::Integer,
                       arr::DenseMatrix{Cdouble},
                       alpha::DenseMatrix{Cdouble},
                       i1::Integer,
                       i2::Integer,
                       j1::Integer,
                       j2::Integer,
                       vmin::Cdouble,
                       vmax::Cdouble,
                       extend::Integer,
                       aff::DenseArray{Cdouble,N}) where {N}
    ccall((:giza_render_alpha, _GIZALIB), Cvoid,
          (Cint, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Cint, Cint,
           Cdouble, Cdouble, Cint, Ptr{Cdouble}),
          xdim, ydim, arr, alpha, i1, i2, j1, j2, vmin, vmax, extend, aff)
end

function _render_alpha(xdim::Integer,
                       ydim::Integer,
                       arr::DenseArray{Cfloat},
                       alpha::DenseArray{Cfloat},
                       i1::Integer,
                       i2::Integer,
                       j1::Integer,
                       j2::Integer,
                       vmin::Cfloat,
                       vmax::Cfloat,
                       extend::Integer,
                       aff::DenseArray{Cfloat,N}) where {N}
    ccall((:giza_render_alpha_float, _GIZALIB), Cvoid,
          (Cint, Cint, Ptr{Cfloat}, Ptr{Cfloat}, Cint, Cint, Cint, Cint,
           Cfloat, Cfloat, Cint, Ptr{Cfloat}),
          xdim, ydim, arr, alpha, i1, i2, j1, j2, vmin, vmax, extend, aff)
end

function draw_pixels(arr::AbstractMatrix{<:Integer},
                     xmin::Real,
                     xmax::Real,
                     ymin::Real,
                     ymax::Real,
                     extend::Integer)
    xdim, ydim = size(arr)
    ccall((:giza_draw_pixels, _GIZALIB), Cvoid,
          (Cint, Cint, Ptr{Cint}, Cint, Cint, Cint, Cint,
           Cdouble, Cdouble, Cdouble, Cdouble, Cint),
          xdim, ydim, _array(Cint, arr), 0, xdim - 1, 0, ydim - 1,
          xmin, xmax, ymin, ymax, extend)
end

function nice_number(x::Real)
    nsub = Ref{Cint}()
    xrnd = ccall((:giza_round, _GIZALIB), Cdouble,
                 (Cdouble, Ptr{Cint}), x, nsub)
    return (xrnd, nsub[])
end

function subpanel(nx::Integer, ny::Integer)
    ccall((:giza_subpanel, _GIZALIB), Cvoid,
          (Cint, Cint), nx, ny)
end

function set_panel(ix::Integer, iy::Integer)
    ccall((:giza_set_panel, _GIZALIB), Cvoid,
          (Cint, Cint), ix, iy)
end

function get_panel()
    ix = Ref{Cint}()
    iy = Ref{Cint}()
    ccall((:giza_get_panel, _GIZALIB), Cvoid,
          (Ptr{Cint}, Ptr{Cint}), ix, iy)
    return (ix[], iy[])
end

for f in (:set_font,
          :set_font_bold,
          :set_font_bold_italic,
          :set_font_italic)
    @eval function $f(font::AbstractString)
        ccall(($(string("giza_",f)), _GIZALIB), Cvoid,
              (Cstring,), font)
    end
end

function get_font()
    len = 200
    buf = Array{UInt8}(undef, len)
    ccall((:giza_get_font, _GIZALIB), Cvoid,
          (Ptr{UInt8}, Cint), buf, len)
    buf[len] = 0
    return unsafe_string(pointer(buf))
end

function set_text_background(ci::Integer)
    ccall((:giza_set_text_background, _GIZALIB), Cvoid, (Cint,), ci)
end

function get_text_background()
    ci = Ref{Cint}()
    ccall((:giza_get_text_background, _GIZALIB), Cvoid, (Ptr{Cint},), ci)
    return ci[]
end

function vector(vx::AbstractMatrix{Tx},
                vy::AbstractMatrix{Ty},
                scale::Real,
                position::Integer,
                aff::AbstractArray{Ta,N},
                blank::Real) where {Tx<:Real, Ty<:Real, Ta<:Real, N}
    @assert size(vx) == size(vy)
    @assert length(aff) == 6
    T = _float(Tx, Ty, Ta)
    xdim, ydim = size(vx)
    _vector(xdim, ydim, _array(T, vx), _array(T, vy),
            0, xdim - 1, 0, ydim - 1,
            scale, position, aff, blank)
end

function _vector(xdim::Integer,
                 ydim::Integer,
                 vx::DenseVector{Cdouble},
                 vy::DenseVector{Cdouble},
                 i1::Integer,
                 i2::Integer,
                 j1::Integer,
                 j2::Integer,
                 scale::Real,
                 position::Integer, # FIXME:
                 aff::DenseArray{Cdouble,N},
                 blank::Real) where {N}
    ccall((:giza_vector, _GIZALIB), Cvoid,
          (Cint, Cint, Ptr{Cdouble}, Ptr{Cdouble},
           Cint, Cint, Cint, Cint, Cdouble, Cint,
           Ptr{Cdouble}, Cdouble),
          xdim, ydim, _array(T, vx), _array(T, vy),
          0, xdim - 1, 0, ydim - 1, scale, position, aff, blank)
end

function _vector(xdim::Integer,
                 ydim::Integer,
                 vx::DenseVector{Cfloat},
                 vy::DenseVector{Cfloat},
                 i1::Integer,
                 i2::Integer,
                 j1::Integer,
                 j2::Integer,
                 scale::Real,
                 position::Integer, # FIXME:
                 aff::DenseArray{Cfloat,N},
                 blank::Real) where {N}
    ccall((:giza_vector_float, _GIZALIB), Cvoid,
          (Cint, Cint, Ptr{Cfloat}, Ptr{Cfloat},
           Cint, Cint, Cint, Cint, Cfloat, Cint,
           Ptr{Cfloat}, Cfloat),
          xdim, ydim, _array(T, vx), _array(T, vy),
          0, xdim - 1, 0, ydim - 1, scale, position, aff, blank)
end

function set_viewport(left::Real, right::Real, bottom::Real, top::Real)
    ccall((:giza_set_viewport, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble),
          left, right, bottom, top)
end

function get_viewport(units::Integer)
    left   = Ref{Cdouble}()
    right  = Ref{Cdouble}()
    bottom = Ref{Cdouble}()
    top    = Ref{Cdouble}()
    ccall((:giza_get_viewport, _GIZALIB), Cvoid,
          (Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          units, left, right, bottom, top)
    return (left[], right[], bottom[], top[])
end

function set_viewport_inches(left::Real, right::Real, bottom::Real, top::Real)
    ccall((:giza_set_viewport_inches, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble),
          left, right, bottom, top)
end

function version()
    major = Ref{Cint}()
    minor = Ref{Cint}()
    micro = Ref{Cint}()
    ccall((:giza_version, _GIZALIB), Cvoid,
          (Ptr{Cint}, Ptr{Cint}, Ptr{Cint}),
          major, minor, micro)
    return (major[], minor[], micro[])
end

function set_window(x1::Real, x2::Real, y1::Real, y2::Real)
    ccall((:giza_set_window, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble),
          x1, x2, y1, y2)
end

function set_window_equal_scale(x1::Real, x2::Real, y1::Real, y2::Real)
    ccall((:giza_set_window_equal_scale, _GIZALIB), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble),
          x1, x2, y1, y2)
end

function get_window()
    x1 = Ref{Cdouble}()
    x2 = Ref{Cdouble}()
    y1 = Ref{Cdouble}()
    y2 = Ref{Cdouble}()
    ccall((:giza_get_window, _GIZALIB), Cvoid,
          (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          x1, x2, y1, y2)
    return (x1[], x2[], y1[], y2[])
end

end # module
