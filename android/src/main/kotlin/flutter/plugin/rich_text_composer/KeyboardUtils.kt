package flutter.plugin.rich_text_composer

import android.content.Context
import android.view.inputmethod.InputMethodManager
object KeyboardUtils {
    fun showSoftInput(context: Context) {
        val inputMethodManager =
            context.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager
        inputMethodManager?.toggleSoftInput(
            InputMethodManager.SHOW_FORCED,
            InputMethodManager.HIDE_IMPLICIT_ONLY
        )
    }
}