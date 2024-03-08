-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_310 is
end project_tb_310;

architecture project_tb_arch_310 of project_tb_310 is
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

constant SCENARIO_LENGTH : integer := 570;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (27,0,92,0,55,0,121,0,158,0,49,0,253,0,34,0,224,0,51,0,0,0,96,0,0,0,174,0,95,0,211,0,0,0,210,0,204,0,152,0,173,0,134,0,73,0,121,0,0,0,7,0,194,0,0,0,34,0,245,0,154,0,56,0,149,0,255,0,62,0,0,0,176,0,209,0,61,0,0,0,132,0,185,0,252,0,204,0,0,0,38,0,217,0,0,0,65,0,18,0,25,0,118,0,73,0,18,0,251,0,0,0,49,0,120,0,130,0,240,0,43,0,73,0,60,0,157,0,167,0,21,0,195,0,0,0,201,0,97,0,64,0,222,0,15,0,155,0,116,0,182,0,77,0,238,0,24,0,181,0,13,0,138,0,13,0,204,0,157,0,64,0,20,0,172,0,0,0,0,0,31,0,150,0,227,0,173,0,0,0,5,0,190,0,30,0,64,0,0,0,0,0,222,0,251,0,178,0,24,0,41,0,34,0,69,0,0,0,147,0,58,0,0,0,73,0,210,0,0,0,181,0,171,0,138,0,0,0,124,0,50,0,62,0,5,0,0,0,169,0,65,0,148,0,221,0,37,0,0,0,234,0,64,0,93,0,238,0,70,0,78,0,13,0,17,0,64,0,0,0,183,0,70,0,249,0,156,0,244,0,18,0,65,0,49,0,250,0,206,0,0,0,7,0,0,0,43,0,34,0,66,0,194,0,132,0,0,0,137,0,50,0,0,0,0,0,0,0,90,0,25,0,55,0,94,0,229,0,212,0,145,0,158,0,175,0,156,0,105,0,59,0,170,0,0,0,59,0,0,0,155,0,0,0,112,0,93,0,139,0,61,0,195,0,105,0,244,0,152,0,9,0,128,0,65,0,169,0,233,0,91,0,28,0,53,0,0,0,207,0,128,0,173,0,83,0,20,0,88,0,167,0,207,0,70,0,213,0,0,0,74,0,74,0,160,0,123,0,190,0,124,0,37,0,244,0,45,0,113,0,114,0,214,0,0,0,235,0,104,0,72,0,9,0,141,0,244,0,37,0,130,0,0,0,214,0,93,0,6,0,66,0,196,0,119,0,92,0,128,0,166,0,77,0,0,0,240,0,0,0,150,0,251,0,251,0,154,0,51,0,252,0,168,0,217,0,28,0,88,0,0,0,10,0,53,0,73,0,33,0,22,0,114,0,56,0,40,0,63,0,0,0,0,0,144,0,168,0,0,0,119,0,175,0,178,0,79,0,243,0,249,0,183,0,246,0,67,0,0,0,109,0,5,0,0,0,58,0,0,0,0,0,72,0,0,0,0,0,166,0,94,0,165,0,45,0,39,0,194,0,143,0,49,0,87,0,173,0,0,0,160,0,224,0,0,0,0,0,159,0,222,0,201,0,207,0,185,0,244,0,0,0,46,0,0,0,154,0,177,0,68,0,44,0,73,0,95,0,0,0,230,0,0,0,236,0,245,0,74,0,21,0,40,0,126,0,42,0,241,0,199,0,155,0,128,0,0,0,100,0,0,0,20,0,0,0,116,0,220,0,33,0,88,0,149,0,108,0,0,0,0,0,57,0,36,0,51,0,53,0,18,0,0,0,0,0,194,0,0,0,250,0,93,0,16,0,31,0,102,0,7,0,252,0,224,0,0,0,139,0,42,0,40,0,35,0,172,0,55,0,207,0,183,0,0,0,146,0,49,0,213,0,50,0,0,0,0,0,0,0,0,0,65,0,143,0,144,0,197,0,146,0,186,0,63,0,9,0,237,0,0,0,90,0,14,0,133,0,169,0,18,0,3,0,218,0,177,0,0,0,119,0,87,0,0,0,165,0,115,0,136,0,179,0,99,0,195,0,31,0,36,0,29,0,110,0,203,0,245,0,91,0,25,0,155,0,7,0,0,0,133,0,24,0,216,0,124,0,60,0,232,0,239,0,53,0,207,0,59,0,112,0,32,0,149,0,178,0,0,0,3,0,123,0,75,0,189,0,21,0,189,0,42,0,0,0,0,0,68,0,126,0,0,0,185,0,191,0,219,0,0,0,5,0,20,0,0,0,0,0,16,0,37,0,0,0,0,0,219,0,238,0,169,0,153,0,155,0,96,0,47,0,184,0,0,0,88,0,0,0,118,0,176,0,0,0,30,0,47,0,146,0,65,0,128,0,24,0,134,0,195,0,97,0,174,0,183,0,0,0,0,0,204,0,172,0,246,0,120,0,212,0,171,0,164,0,30,0,201,0,226,0,167,0,237,0,0,0,4,0,142,0,54,0,212,0,0,0,195,0,0,0,213,0,219,0,24,0,27,0,177,0,231,0,243,0,172,0,41,0,101,0,133,0,101,0,211,0,145,0,9,0,169,0,17,0,145,0,0,0,148,0,249,0,38,0,3,0,181,0,45,0,231,0,9,0,42,0,0,0,0,0,186,0,233,0,138,0,0,0,0,0,141,0,146,0,179,0,44,0,73,0,156,0,167,0,143,0,0,0,48,0,254,0,0,0,0,0,119,0,234,0,37,0,191,0,203,0,0,0,18,0,15,0,59,0,201,0,201,0,0,0,238,0,163,0,118,0,0,0);
signal scenario_full  : scenario_type := (27,31,92,31,55,31,121,31,158,31,49,31,253,31,34,31,224,31,51,31,51,30,96,31,96,30,174,31,95,31,211,31,211,30,210,31,204,31,152,31,173,31,134,31,73,31,121,31,121,30,7,31,194,31,194,30,34,31,245,31,154,31,56,31,149,31,255,31,62,31,62,30,176,31,209,31,61,31,61,30,132,31,185,31,252,31,204,31,204,30,38,31,217,31,217,30,65,31,18,31,25,31,118,31,73,31,18,31,251,31,251,30,49,31,120,31,130,31,240,31,43,31,73,31,60,31,157,31,167,31,21,31,195,31,195,30,201,31,97,31,64,31,222,31,15,31,155,31,116,31,182,31,77,31,238,31,24,31,181,31,13,31,138,31,13,31,204,31,157,31,64,31,20,31,172,31,172,30,172,29,31,31,150,31,227,31,173,31,173,30,5,31,190,31,30,31,64,31,64,30,64,29,222,31,251,31,178,31,24,31,41,31,34,31,69,31,69,30,147,31,58,31,58,30,73,31,210,31,210,30,181,31,171,31,138,31,138,30,124,31,50,31,62,31,5,31,5,30,169,31,65,31,148,31,221,31,37,31,37,30,234,31,64,31,93,31,238,31,70,31,78,31,13,31,17,31,64,31,64,30,183,31,70,31,249,31,156,31,244,31,18,31,65,31,49,31,250,31,206,31,206,30,7,31,7,30,43,31,34,31,66,31,194,31,132,31,132,30,137,31,50,31,50,30,50,29,50,28,90,31,25,31,55,31,94,31,229,31,212,31,145,31,158,31,175,31,156,31,105,31,59,31,170,31,170,30,59,31,59,30,155,31,155,30,112,31,93,31,139,31,61,31,195,31,105,31,244,31,152,31,9,31,128,31,65,31,169,31,233,31,91,31,28,31,53,31,53,30,207,31,128,31,173,31,83,31,20,31,88,31,167,31,207,31,70,31,213,31,213,30,74,31,74,31,160,31,123,31,190,31,124,31,37,31,244,31,45,31,113,31,114,31,214,31,214,30,235,31,104,31,72,31,9,31,141,31,244,31,37,31,130,31,130,30,214,31,93,31,6,31,66,31,196,31,119,31,92,31,128,31,166,31,77,31,77,30,240,31,240,30,150,31,251,31,251,31,154,31,51,31,252,31,168,31,217,31,28,31,88,31,88,30,10,31,53,31,73,31,33,31,22,31,114,31,56,31,40,31,63,31,63,30,63,29,144,31,168,31,168,30,119,31,175,31,178,31,79,31,243,31,249,31,183,31,246,31,67,31,67,30,109,31,5,31,5,30,58,31,58,30,58,29,72,31,72,30,72,29,166,31,94,31,165,31,45,31,39,31,194,31,143,31,49,31,87,31,173,31,173,30,160,31,224,31,224,30,224,29,159,31,222,31,201,31,207,31,185,31,244,31,244,30,46,31,46,30,154,31,177,31,68,31,44,31,73,31,95,31,95,30,230,31,230,30,236,31,245,31,74,31,21,31,40,31,126,31,42,31,241,31,199,31,155,31,128,31,128,30,100,31,100,30,20,31,20,30,116,31,220,31,33,31,88,31,149,31,108,31,108,30,108,29,57,31,36,31,51,31,53,31,18,31,18,30,18,29,194,31,194,30,250,31,93,31,16,31,31,31,102,31,7,31,252,31,224,31,224,30,139,31,42,31,40,31,35,31,172,31,55,31,207,31,183,31,183,30,146,31,49,31,213,31,50,31,50,30,50,29,50,28,50,27,65,31,143,31,144,31,197,31,146,31,186,31,63,31,9,31,237,31,237,30,90,31,14,31,133,31,169,31,18,31,3,31,218,31,177,31,177,30,119,31,87,31,87,30,165,31,115,31,136,31,179,31,99,31,195,31,31,31,36,31,29,31,110,31,203,31,245,31,91,31,25,31,155,31,7,31,7,30,133,31,24,31,216,31,124,31,60,31,232,31,239,31,53,31,207,31,59,31,112,31,32,31,149,31,178,31,178,30,3,31,123,31,75,31,189,31,21,31,189,31,42,31,42,30,42,29,68,31,126,31,126,30,185,31,191,31,219,31,219,30,5,31,20,31,20,30,20,29,16,31,37,31,37,30,37,29,219,31,238,31,169,31,153,31,155,31,96,31,47,31,184,31,184,30,88,31,88,30,118,31,176,31,176,30,30,31,47,31,146,31,65,31,128,31,24,31,134,31,195,31,97,31,174,31,183,31,183,30,183,29,204,31,172,31,246,31,120,31,212,31,171,31,164,31,30,31,201,31,226,31,167,31,237,31,237,30,4,31,142,31,54,31,212,31,212,30,195,31,195,30,213,31,219,31,24,31,27,31,177,31,231,31,243,31,172,31,41,31,101,31,133,31,101,31,211,31,145,31,9,31,169,31,17,31,145,31,145,30,148,31,249,31,38,31,3,31,181,31,45,31,231,31,9,31,42,31,42,30,42,29,186,31,233,31,138,31,138,30,138,29,141,31,146,31,179,31,44,31,73,31,156,31,167,31,143,31,143,30,48,31,254,31,254,30,254,29,119,31,234,31,37,31,191,31,203,31,203,30,18,31,15,31,59,31,201,31,201,31,201,30,238,31,163,31,118,31,118,30);

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
