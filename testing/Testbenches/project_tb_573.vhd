-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_573 is
end project_tb_573;

architecture project_tb_arch_573 of project_tb_573 is
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

constant SCENARIO_LENGTH : integer := 437;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (66,0,0,0,0,0,104,0,197,0,165,0,85,0,229,0,27,0,121,0,199,0,0,0,201,0,135,0,5,0,85,0,226,0,0,0,185,0,0,0,0,0,49,0,222,0,117,0,195,0,137,0,0,0,140,0,205,0,0,0,49,0,221,0,242,0,59,0,10,0,191,0,78,0,239,0,0,0,239,0,0,0,141,0,156,0,253,0,185,0,0,0,234,0,153,0,217,0,58,0,0,0,168,0,64,0,97,0,125,0,167,0,117,0,77,0,0,0,122,0,159,0,125,0,234,0,82,0,35,0,0,0,211,0,48,0,29,0,110,0,10,0,0,0,0,0,0,0,73,0,37,0,130,0,188,0,224,0,253,0,208,0,197,0,55,0,128,0,91,0,88,0,215,0,117,0,107,0,205,0,88,0,36,0,177,0,128,0,223,0,34,0,0,0,58,0,54,0,110,0,207,0,144,0,169,0,63,0,64,0,88,0,182,0,19,0,197,0,175,0,159,0,159,0,204,0,248,0,134,0,80,0,228,0,20,0,86,0,58,0,242,0,255,0,0,0,130,0,230,0,68,0,188,0,152,0,135,0,41,0,108,0,0,0,98,0,132,0,237,0,13,0,192,0,226,0,96,0,110,0,90,0,152,0,254,0,40,0,117,0,215,0,84,0,202,0,190,0,254,0,0,0,101,0,89,0,34,0,21,0,152,0,0,0,250,0,0,0,0,0,190,0,201,0,35,0,183,0,222,0,228,0,233,0,0,0,118,0,173,0,160,0,222,0,0,0,168,0,0,0,172,0,0,0,157,0,28,0,204,0,0,0,238,0,0,0,3,0,200,0,234,0,0,0,72,0,17,0,29,0,64,0,108,0,240,0,168,0,198,0,202,0,158,0,201,0,174,0,47,0,184,0,53,0,37,0,189,0,164,0,78,0,213,0,112,0,0,0,209,0,210,0,24,0,143,0,73,0,0,0,13,0,254,0,43,0,21,0,0,0,183,0,72,0,0,0,0,0,96,0,190,0,0,0,49,0,125,0,107,0,66,0,0,0,60,0,25,0,0,0,116,0,0,0,213,0,11,0,77,0,204,0,177,0,60,0,223,0,44,0,0,0,158,0,117,0,0,0,37,0,155,0,65,0,31,0,114,0,0,0,38,0,96,0,158,0,145,0,53,0,98,0,2,0,4,0,44,0,246,0,251,0,60,0,0,0,187,0,202,0,126,0,30,0,0,0,139,0,100,0,77,0,0,0,0,0,233,0,205,0,0,0,0,0,220,0,246,0,0,0,14,0,216,0,0,0,3,0,161,0,111,0,34,0,238,0,165,0,13,0,136,0,188,0,213,0,121,0,0,0,106,0,131,0,235,0,241,0,255,0,207,0,0,0,58,0,125,0,199,0,0,0,210,0,139,0,184,0,29,0,0,0,102,0,108,0,243,0,0,0,0,0,0,0,166,0,177,0,3,0,62,0,71,0,12,0,14,0,0,0,33,0,210,0,28,0,0,0,87,0,148,0,50,0,136,0,160,0,0,0,0,0,227,0,24,0,78,0,226,0,0,0,0,0,44,0,47,0,48,0,60,0,0,0,131,0,62,0,216,0,252,0,134,0,237,0,16,0,0,0,50,0,219,0,117,0,20,0,55,0,87,0,60,0,36,0,164,0,0,0,251,0,28,0,240,0,175,0,102,0,101,0,93,0,180,0,183,0,98,0,233,0,32,0,208,0,138,0,116,0,178,0,2,0,0,0,0,0,80,0,10,0,0,0,182,0,167,0,194,0,114,0,240,0,37,0,175,0,122,0,27,0,78,0,162,0,226,0,6,0,0,0,55,0,250,0,184,0,244,0,19,0,229,0,244,0,30,0,118,0,103,0,13,0,0,0,109,0,73,0,187,0,116,0,0,0,22,0,0,0,231,0,201,0,24,0,0,0,98,0,205,0,140,0,0,0,0,0,226,0,214,0,245,0);
signal scenario_full  : scenario_type := (66,31,66,30,66,29,104,31,197,31,165,31,85,31,229,31,27,31,121,31,199,31,199,30,201,31,135,31,5,31,85,31,226,31,226,30,185,31,185,30,185,29,49,31,222,31,117,31,195,31,137,31,137,30,140,31,205,31,205,30,49,31,221,31,242,31,59,31,10,31,191,31,78,31,239,31,239,30,239,31,239,30,141,31,156,31,253,31,185,31,185,30,234,31,153,31,217,31,58,31,58,30,168,31,64,31,97,31,125,31,167,31,117,31,77,31,77,30,122,31,159,31,125,31,234,31,82,31,35,31,35,30,211,31,48,31,29,31,110,31,10,31,10,30,10,29,10,28,73,31,37,31,130,31,188,31,224,31,253,31,208,31,197,31,55,31,128,31,91,31,88,31,215,31,117,31,107,31,205,31,88,31,36,31,177,31,128,31,223,31,34,31,34,30,58,31,54,31,110,31,207,31,144,31,169,31,63,31,64,31,88,31,182,31,19,31,197,31,175,31,159,31,159,31,204,31,248,31,134,31,80,31,228,31,20,31,86,31,58,31,242,31,255,31,255,30,130,31,230,31,68,31,188,31,152,31,135,31,41,31,108,31,108,30,98,31,132,31,237,31,13,31,192,31,226,31,96,31,110,31,90,31,152,31,254,31,40,31,117,31,215,31,84,31,202,31,190,31,254,31,254,30,101,31,89,31,34,31,21,31,152,31,152,30,250,31,250,30,250,29,190,31,201,31,35,31,183,31,222,31,228,31,233,31,233,30,118,31,173,31,160,31,222,31,222,30,168,31,168,30,172,31,172,30,157,31,28,31,204,31,204,30,238,31,238,30,3,31,200,31,234,31,234,30,72,31,17,31,29,31,64,31,108,31,240,31,168,31,198,31,202,31,158,31,201,31,174,31,47,31,184,31,53,31,37,31,189,31,164,31,78,31,213,31,112,31,112,30,209,31,210,31,24,31,143,31,73,31,73,30,13,31,254,31,43,31,21,31,21,30,183,31,72,31,72,30,72,29,96,31,190,31,190,30,49,31,125,31,107,31,66,31,66,30,60,31,25,31,25,30,116,31,116,30,213,31,11,31,77,31,204,31,177,31,60,31,223,31,44,31,44,30,158,31,117,31,117,30,37,31,155,31,65,31,31,31,114,31,114,30,38,31,96,31,158,31,145,31,53,31,98,31,2,31,4,31,44,31,246,31,251,31,60,31,60,30,187,31,202,31,126,31,30,31,30,30,139,31,100,31,77,31,77,30,77,29,233,31,205,31,205,30,205,29,220,31,246,31,246,30,14,31,216,31,216,30,3,31,161,31,111,31,34,31,238,31,165,31,13,31,136,31,188,31,213,31,121,31,121,30,106,31,131,31,235,31,241,31,255,31,207,31,207,30,58,31,125,31,199,31,199,30,210,31,139,31,184,31,29,31,29,30,102,31,108,31,243,31,243,30,243,29,243,28,166,31,177,31,3,31,62,31,71,31,12,31,14,31,14,30,33,31,210,31,28,31,28,30,87,31,148,31,50,31,136,31,160,31,160,30,160,29,227,31,24,31,78,31,226,31,226,30,226,29,44,31,47,31,48,31,60,31,60,30,131,31,62,31,216,31,252,31,134,31,237,31,16,31,16,30,50,31,219,31,117,31,20,31,55,31,87,31,60,31,36,31,164,31,164,30,251,31,28,31,240,31,175,31,102,31,101,31,93,31,180,31,183,31,98,31,233,31,32,31,208,31,138,31,116,31,178,31,2,31,2,30,2,29,80,31,10,31,10,30,182,31,167,31,194,31,114,31,240,31,37,31,175,31,122,31,27,31,78,31,162,31,226,31,6,31,6,30,55,31,250,31,184,31,244,31,19,31,229,31,244,31,30,31,118,31,103,31,13,31,13,30,109,31,73,31,187,31,116,31,116,30,22,31,22,30,231,31,201,31,24,31,24,30,98,31,205,31,140,31,140,30,140,29,226,31,214,31,245,31);

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
