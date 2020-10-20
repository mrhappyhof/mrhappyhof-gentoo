# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="https://gitlab.freedesktop.org/libfprint/fprintd"
SRC_URI="https://gitlab.freedesktop.org/libfprint/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-libs/libgusb
sys-auth/libfprint
sys-libs/pam_wrapper
dev-python/dbusmock
dev-python/dbus-python
sys-auth/elogind
sys-apps/openrc
sys-libs/pam
doc? ( dev-util/gtk-doc dev-util/gtk-doc-am dev-libs/libxml2 dev-libs/libxslt )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare(){
    eapply "${FILESDIR}/${PV}-elogind.patch"
    eapply_user
}

src_configure(){
	local emesonargs=(
		$(meson_use doc gtk_doc)
		--prefix=/usr/
	)
	meson_src_configure
}

src_compile(){
	meson_src_compile
}

src_install(){
	meson_src_install
}

