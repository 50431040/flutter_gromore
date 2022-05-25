package net.niuxiaoer.flutter_gromore.event

class AdEvent(private val id: String, private val name: String) {

    fun toMap(): HashMap<String, Any> {
        return HashMap<String, Any>().apply {
            set("id", id)
            set("name", name)
        }
    }

}