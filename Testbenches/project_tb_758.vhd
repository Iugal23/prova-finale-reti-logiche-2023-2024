-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 539;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (218,0,24,0,123,0,70,0,151,0,175,0,103,0,11,0,194,0,0,0,74,0,10,0,237,0,26,0,179,0,127,0,189,0,52,0,57,0,221,0,175,0,0,0,163,0,0,0,0,0,72,0,212,0,0,0,240,0,0,0,90,0,0,0,187,0,206,0,0,0,137,0,180,0,76,0,165,0,39,0,133,0,34,0,0,0,252,0,115,0,35,0,0,0,184,0,66,0,135,0,0,0,217,0,183,0,201,0,81,0,0,0,181,0,151,0,0,0,237,0,145,0,0,0,35,0,65,0,45,0,129,0,15,0,46,0,11,0,222,0,0,0,126,0,92,0,0,0,177,0,37,0,224,0,34,0,8,0,216,0,74,0,218,0,100,0,0,0,124,0,124,0,23,0,0,0,117,0,0,0,230,0,183,0,56,0,118,0,212,0,64,0,0,0,0,0,48,0,167,0,0,0,188,0,64,0,0,0,240,0,45,0,111,0,105,0,0,0,0,0,181,0,131,0,85,0,187,0,222,0,125,0,134,0,0,0,25,0,57,0,13,0,0,0,103,0,211,0,187,0,0,0,0,0,212,0,46,0,176,0,37,0,85,0,98,0,0,0,114,0,97,0,250,0,0,0,144,0,47,0,169,0,164,0,0,0,177,0,25,0,0,0,130,0,197,0,0,0,215,0,112,0,0,0,0,0,199,0,140,0,46,0,113,0,237,0,0,0,104,0,179,0,0,0,109,0,20,0,10,0,33,0,154,0,0,0,40,0,1,0,0,0,250,0,146,0,203,0,189,0,101,0,126,0,129,0,164,0,13,0,235,0,195,0,164,0,248,0,177,0,201,0,206,0,240,0,223,0,37,0,63,0,210,0,180,0,0,0,129,0,0,0,12,0,10,0,141,0,0,0,195,0,45,0,0,0,159,0,186,0,11,0,0,0,241,0,241,0,23,0,171,0,0,0,42,0,80,0,9,0,80,0,65,0,118,0,0,0,113,0,0,0,21,0,231,0,187,0,0,0,146,0,131,0,74,0,2,0,162,0,0,0,0,0,154,0,174,0,0,0,81,0,2,0,235,0,117,0,0,0,220,0,247,0,126,0,124,0,135,0,0,0,4,0,117,0,90,0,0,0,179,0,218,0,0,0,223,0,159,0,166,0,36,0,204,0,92,0,204,0,0,0,14,0,213,0,244,0,250,0,152,0,217,0,119,0,154,0,186,0,16,0,179,0,149,0,148,0,159,0,20,0,216,0,146,0,221,0,0,0,59,0,0,0,32,0,31,0,61,0,145,0,60,0,170,0,0,0,187,0,7,0,90,0,17,0,238,0,0,0,139,0,167,0,0,0,23,0,37,0,117,0,189,0,0,0,192,0,195,0,0,0,0,0,97,0,185,0,234,0,204,0,210,0,209,0,187,0,212,0,171,0,0,0,141,0,0,0,224,0,230,0,210,0,0,0,179,0,180,0,55,0,0,0,0,0,231,0,162,0,65,0,167,0,103,0,132,0,112,0,0,0,172,0,91,0,204,0,240,0,0,0,0,0,0,0,0,0,0,0,0,0,70,0,232,0,80,0,69,0,70,0,125,0,154,0,0,0,0,0,0,0,3,0,112,0,225,0,157,0,120,0,185,0,58,0,148,0,168,0,0,0,182,0,186,0,240,0,10,0,220,0,0,0,175,0,90,0,65,0,103,0,166,0,69,0,156,0,237,0,125,0,220,0,0,0,47,0,11,0,207,0,49,0,97,0,8,0,0,0,71,0,151,0,0,0,60,0,230,0,162,0,130,0,199,0,151,0,248,0,0,0,219,0,191,0,0,0,0,0,0,0,184,0,0,0,38,0,0,0,134,0,246,0,0,0,56,0,123,0,121,0,231,0,148,0,0,0,0,0,11,0,0,0,118,0,144,0,0,0,200,0,200,0,245,0,183,0,16,0,49,0,0,0,188,0,160,0,106,0,128,0,46,0,0,0,237,0,169,0,21,0,158,0,72,0,81,0,63,0,85,0,137,0,92,0,156,0,183,0,151,0,85,0,150,0,92,0,0,0,55,0,110,0,125,0,62,0,143,0,7,0,168,0,0,0,0,0,57,0,192,0,199,0,0,0,164,0,47,0,48,0,0,0,0,0,198,0,215,0,110,0,161,0,187,0,238,0,101,0,207,0,118,0,208,0,250,0,153,0,61,0,143,0,0,0,0,0,178,0,222,0,163,0,239,0,249,0,91,0,31,0,75,0,116,0,51,0,142,0,41,0,247,0,239,0,20,0,228,0,138,0,238,0,217,0,210,0,105,0,0,0,246,0,0,0,0,0,42,0,68,0,154,0,56,0,145,0,115,0,87,0,0,0,69,0,83,0,81,0,8,0,0,0,175,0,51,0,0,0,108,0,205,0,149,0,0,0,79,0,0,0,6,0,176,0,55,0);
signal scenario_full  : scenario_type := (218,31,24,31,123,31,70,31,151,31,175,31,103,31,11,31,194,31,194,30,74,31,10,31,237,31,26,31,179,31,127,31,189,31,52,31,57,31,221,31,175,31,175,30,163,31,163,30,163,29,72,31,212,31,212,30,240,31,240,30,90,31,90,30,187,31,206,31,206,30,137,31,180,31,76,31,165,31,39,31,133,31,34,31,34,30,252,31,115,31,35,31,35,30,184,31,66,31,135,31,135,30,217,31,183,31,201,31,81,31,81,30,181,31,151,31,151,30,237,31,145,31,145,30,35,31,65,31,45,31,129,31,15,31,46,31,11,31,222,31,222,30,126,31,92,31,92,30,177,31,37,31,224,31,34,31,8,31,216,31,74,31,218,31,100,31,100,30,124,31,124,31,23,31,23,30,117,31,117,30,230,31,183,31,56,31,118,31,212,31,64,31,64,30,64,29,48,31,167,31,167,30,188,31,64,31,64,30,240,31,45,31,111,31,105,31,105,30,105,29,181,31,131,31,85,31,187,31,222,31,125,31,134,31,134,30,25,31,57,31,13,31,13,30,103,31,211,31,187,31,187,30,187,29,212,31,46,31,176,31,37,31,85,31,98,31,98,30,114,31,97,31,250,31,250,30,144,31,47,31,169,31,164,31,164,30,177,31,25,31,25,30,130,31,197,31,197,30,215,31,112,31,112,30,112,29,199,31,140,31,46,31,113,31,237,31,237,30,104,31,179,31,179,30,109,31,20,31,10,31,33,31,154,31,154,30,40,31,1,31,1,30,250,31,146,31,203,31,189,31,101,31,126,31,129,31,164,31,13,31,235,31,195,31,164,31,248,31,177,31,201,31,206,31,240,31,223,31,37,31,63,31,210,31,180,31,180,30,129,31,129,30,12,31,10,31,141,31,141,30,195,31,45,31,45,30,159,31,186,31,11,31,11,30,241,31,241,31,23,31,171,31,171,30,42,31,80,31,9,31,80,31,65,31,118,31,118,30,113,31,113,30,21,31,231,31,187,31,187,30,146,31,131,31,74,31,2,31,162,31,162,30,162,29,154,31,174,31,174,30,81,31,2,31,235,31,117,31,117,30,220,31,247,31,126,31,124,31,135,31,135,30,4,31,117,31,90,31,90,30,179,31,218,31,218,30,223,31,159,31,166,31,36,31,204,31,92,31,204,31,204,30,14,31,213,31,244,31,250,31,152,31,217,31,119,31,154,31,186,31,16,31,179,31,149,31,148,31,159,31,20,31,216,31,146,31,221,31,221,30,59,31,59,30,32,31,31,31,61,31,145,31,60,31,170,31,170,30,187,31,7,31,90,31,17,31,238,31,238,30,139,31,167,31,167,30,23,31,37,31,117,31,189,31,189,30,192,31,195,31,195,30,195,29,97,31,185,31,234,31,204,31,210,31,209,31,187,31,212,31,171,31,171,30,141,31,141,30,224,31,230,31,210,31,210,30,179,31,180,31,55,31,55,30,55,29,231,31,162,31,65,31,167,31,103,31,132,31,112,31,112,30,172,31,91,31,204,31,240,31,240,30,240,29,240,28,240,27,240,26,240,25,70,31,232,31,80,31,69,31,70,31,125,31,154,31,154,30,154,29,154,28,3,31,112,31,225,31,157,31,120,31,185,31,58,31,148,31,168,31,168,30,182,31,186,31,240,31,10,31,220,31,220,30,175,31,90,31,65,31,103,31,166,31,69,31,156,31,237,31,125,31,220,31,220,30,47,31,11,31,207,31,49,31,97,31,8,31,8,30,71,31,151,31,151,30,60,31,230,31,162,31,130,31,199,31,151,31,248,31,248,30,219,31,191,31,191,30,191,29,191,28,184,31,184,30,38,31,38,30,134,31,246,31,246,30,56,31,123,31,121,31,231,31,148,31,148,30,148,29,11,31,11,30,118,31,144,31,144,30,200,31,200,31,245,31,183,31,16,31,49,31,49,30,188,31,160,31,106,31,128,31,46,31,46,30,237,31,169,31,21,31,158,31,72,31,81,31,63,31,85,31,137,31,92,31,156,31,183,31,151,31,85,31,150,31,92,31,92,30,55,31,110,31,125,31,62,31,143,31,7,31,168,31,168,30,168,29,57,31,192,31,199,31,199,30,164,31,47,31,48,31,48,30,48,29,198,31,215,31,110,31,161,31,187,31,238,31,101,31,207,31,118,31,208,31,250,31,153,31,61,31,143,31,143,30,143,29,178,31,222,31,163,31,239,31,249,31,91,31,31,31,75,31,116,31,51,31,142,31,41,31,247,31,239,31,20,31,228,31,138,31,238,31,217,31,210,31,105,31,105,30,246,31,246,30,246,29,42,31,68,31,154,31,56,31,145,31,115,31,87,31,87,30,69,31,83,31,81,31,8,31,8,30,175,31,51,31,51,30,108,31,205,31,149,31,149,30,79,31,79,30,6,31,176,31,55,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
