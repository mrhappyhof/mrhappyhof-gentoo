# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam meson

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="https://gitlab.freedesktop.org/libfprint/fprintd"
SRC_URI="https://gitlab.freedesktop.org/libfprint/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc pam static-libs systemd"

DEPEND="systemd? ( sys-apps/systemd )
	!systemd ( sys-auth/elogind)
	sys-apps/dbus
	dev-libs/dbus-glib
	dev-libs/glib:2
	>=sys-auth/libfprint-1.90.0
	sys-auth/polkit
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}
	dev-python/dbus-python
	dev-python/dbusmock
	dev-python/pycairo
	pam? ( >=sys-auth/pam_wrapper-1.1.0 )
	doc? (
		dev-util/gtk-doc
		dev-util/gtk-doc-am
	)"

BDEPEND="virtual/pkgconfig"

src_prepare(){
    use systemd || eapply "${FILESDIR}/${PV}-elogind.patch"
    eapply_user
}

src_configure(){
	local emesonargs=(
		-Dpam=$(usex pam true false)
		-Dman=true
		--prefix=/usr/
		-Dpam_modules_dir="$(getpam_mod_dir)"
		-Dgtk_doc=$(usex doc true false)
	)
	meson_src_configure
}

src_compile(){
	meson_src_compile
}

src_install(){
	meson_src_install
}

