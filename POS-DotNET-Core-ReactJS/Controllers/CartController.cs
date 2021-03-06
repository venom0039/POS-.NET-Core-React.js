using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using POS_DotNET_Core_ReactJS.Data;
using POS_DotNET_Core_ReactJS.Models;
using POS_DotNET_Core_ReactJS.Models.DTO;

namespace POS_DotNET_Core_ReactJS.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CartController : ControllerBase
    {
        CartContext db = new CartContext();

        [HttpGet("{id}")]
        public async Task<ActionResult<List<Cart>>> GetAllCarts(int id)
        {
            List<CartGetDTO> grn = db.GetCarts(id).ToList();
            return Ok(grn);
        }

        [HttpGet("GetSingle/{id}")]
        public async Task<ActionResult<Cart>> GetSingle(int id)
        {
            CartGetDTO cart = db.GetCartOnce(id);
            if(cart.CartID == 0)
            {
                return NotFound();
            }
            else
            {
                return Ok(cart);
            }
        }

        [HttpPost]
        public async Task<ActionResult<Cart>> PostCart(CartAddDTO obj)
        {
            if (ModelState.IsValid)
            {
                var isOK = db.PostCarts(obj);
                return Ok(isOK);
            }
            else
            {
                return BadRequest();
            }
        }

        [HttpPut]
        public async Task<ActionResult<Cart>> EditCart(Cart obj)
        {
            if (ModelState.IsValid)
            {
                var isOK = db.EditCarts(obj);
                if (isOK)
                {
                    return Ok(isOK);
                }
                else
                {
                    return NotFound();
                }
            }
            else
            {
                return BadRequest();
            }
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<Cart>> DeleteCart(int id)
        {
            if (ModelState.IsValid)
            {
                var isOK = db.DeleteCarts(id);
                if (isOK)
                {
                    return Ok(isOK);
                }
                else
                {
                    return NotFound();
                }
            }
            else
            {
                return BadRequest();
            }
        }
    }
}
