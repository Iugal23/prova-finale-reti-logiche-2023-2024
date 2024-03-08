-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_66 is
end project_tb_66;

architecture project_tb_arch_66 of project_tb_66 is
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

constant SCENARIO_LENGTH : integer := 627;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (147,0,39,0,51,0,119,0,45,0,187,0,36,0,148,0,207,0,61,0,186,0,221,0,238,0,227,0,162,0,122,0,28,0,143,0,238,0,37,0,41,0,147,0,243,0,0,0,139,0,99,0,46,0,252,0,0,0,231,0,221,0,27,0,89,0,186,0,87,0,0,0,0,0,11,0,231,0,202,0,84,0,159,0,95,0,220,0,181,0,153,0,80,0,38,0,166,0,53,0,201,0,0,0,132,0,0,0,58,0,249,0,0,0,113,0,0,0,147,0,188,0,12,0,0,0,130,0,148,0,150,0,211,0,110,0,148,0,183,0,0,0,0,0,215,0,44,0,83,0,48,0,114,0,0,0,73,0,0,0,49,0,82,0,122,0,7,0,100,0,0,0,0,0,83,0,0,0,251,0,0,0,21,0,77,0,114,0,120,0,122,0,71,0,224,0,214,0,135,0,36,0,0,0,0,0,133,0,128,0,61,0,217,0,0,0,0,0,202,0,45,0,140,0,208,0,0,0,194,0,74,0,0,0,245,0,231,0,0,0,185,0,239,0,109,0,41,0,103,0,212,0,146,0,0,0,137,0,196,0,56,0,87,0,153,0,58,0,0,0,146,0,251,0,178,0,29,0,167,0,43,0,128,0,131,0,106,0,80,0,6,0,253,0,219,0,40,0,192,0,135,0,158,0,0,0,10,0,3,0,175,0,131,0,0,0,0,0,96,0,49,0,64,0,80,0,100,0,49,0,19,0,234,0,72,0,46,0,173,0,249,0,162,0,0,0,185,0,94,0,243,0,9,0,81,0,102,0,0,0,113,0,249,0,92,0,43,0,30,0,95,0,0,0,198,0,70,0,0,0,144,0,232,0,0,0,1,0,47,0,77,0,164,0,15,0,170,0,147,0,0,0,148,0,134,0,0,0,225,0,248,0,226,0,53,0,0,0,93,0,229,0,154,0,0,0,31,0,82,0,145,0,213,0,33,0,229,0,81,0,23,0,0,0,106,0,106,0,235,0,66,0,126,0,244,0,0,0,229,0,196,0,85,0,238,0,0,0,234,0,114,0,98,0,0,0,243,0,0,0,212,0,8,0,0,0,58,0,0,0,109,0,170,0,43,0,231,0,75,0,184,0,0,0,234,0,0,0,203,0,169,0,97,0,0,0,131,0,0,0,147,0,160,0,217,0,240,0,124,0,123,0,0,0,0,0,50,0,28,0,0,0,66,0,0,0,124,0,97,0,117,0,198,0,72,0,0,0,31,0,192,0,186,0,157,0,0,0,226,0,165,0,163,0,2,0,116,0,0,0,122,0,45,0,239,0,151,0,71,0,0,0,0,0,0,0,91,0,99,0,177,0,183,0,0,0,199,0,112,0,156,0,166,0,169,0,0,0,247,0,0,0,205,0,197,0,69,0,207,0,68,0,0,0,0,0,230,0,26,0,5,0,0,0,0,0,154,0,134,0,222,0,203,0,53,0,150,0,0,0,31,0,253,0,0,0,0,0,0,0,0,0,67,0,49,0,0,0,194,0,0,0,194,0,0,0,174,0,0,0,173,0,193,0,123,0,0,0,118,0,220,0,0,0,194,0,234,0,0,0,85,0,6,0,91,0,104,0,226,0,240,0,247,0,191,0,52,0,236,0,148,0,147,0,0,0,122,0,101,0,0,0,91,0,186,0,90,0,238,0,0,0,0,0,0,0,174,0,242,0,215,0,207,0,0,0,75,0,238,0,124,0,78,0,251,0,29,0,203,0,0,0,202,0,120,0,210,0,142,0,218,0,0,0,29,0,55,0,0,0,244,0,1,0,93,0,185,0,0,0,96,0,195,0,33,0,62,0,15,0,0,0,184,0,254,0,159,0,162,0,62,0,220,0,0,0,21,0,197,0,64,0,39,0,71,0,0,0,132,0,67,0,0,0,191,0,68,0,108,0,0,0,6,0,80,0,162,0,202,0,33,0,0,0,122,0,116,0,0,0,222,0,0,0,136,0,161,0,130,0,199,0,0,0,182,0,0,0,0,0,140,0,40,0,50,0,150,0,232,0,0,0,0,0,137,0,55,0,165,0,90,0,3,0,38,0,0,0,137,0,137,0,0,0,105,0,7,0,86,0,1,0,0,0,7,0,88,0,10,0,4,0,0,0,235,0,203,0,45,0,68,0,0,0,145,0,0,0,96,0,174,0,0,0,59,0,27,0,173,0,59,0,179,0,254,0,153,0,73,0,0,0,42,0,107,0,188,0,199,0,79,0,61,0,111,0,211,0,19,0,28,0,221,0,192,0,46,0,32,0,24,0,119,0,222,0,182,0,28,0,0,0,0,0,112,0,0,0,151,0,215,0,72,0,0,0,239,0,198,0,114,0,208,0,187,0,174,0,160,0,230,0,210,0,169,0,89,0,24,0,165,0,48,0,90,0,89,0,0,0,0,0,0,0,242,0,73,0,0,0,12,0,254,0,83,0,0,0,138,0,157,0,0,0,199,0,24,0,123,0,86,0,83,0,8,0,123,0,137,0,0,0,165,0,92,0,0,0,179,0,49,0,87,0,0,0,0,0,227,0,238,0,147,0,0,0,0,0,0,0,84,0,0,0,209,0,83,0,50,0,244,0,99,0,172,0,214,0,67,0,223,0,90,0,117,0,84,0,221,0,0,0,125,0,157,0,3,0,204,0,125,0,117,0,211,0,112,0,2,0,0,0,0,0,122,0,21,0,3,0,10,0,3,0,56,0,172,0,214,0,94,0,18,0,0,0,15,0,223,0,239,0,2,0,0,0,139,0,10,0,216,0,132,0,2,0,67,0,0,0,231,0,28,0);
signal scenario_full  : scenario_type := (147,31,39,31,51,31,119,31,45,31,187,31,36,31,148,31,207,31,61,31,186,31,221,31,238,31,227,31,162,31,122,31,28,31,143,31,238,31,37,31,41,31,147,31,243,31,243,30,139,31,99,31,46,31,252,31,252,30,231,31,221,31,27,31,89,31,186,31,87,31,87,30,87,29,11,31,231,31,202,31,84,31,159,31,95,31,220,31,181,31,153,31,80,31,38,31,166,31,53,31,201,31,201,30,132,31,132,30,58,31,249,31,249,30,113,31,113,30,147,31,188,31,12,31,12,30,130,31,148,31,150,31,211,31,110,31,148,31,183,31,183,30,183,29,215,31,44,31,83,31,48,31,114,31,114,30,73,31,73,30,49,31,82,31,122,31,7,31,100,31,100,30,100,29,83,31,83,30,251,31,251,30,21,31,77,31,114,31,120,31,122,31,71,31,224,31,214,31,135,31,36,31,36,30,36,29,133,31,128,31,61,31,217,31,217,30,217,29,202,31,45,31,140,31,208,31,208,30,194,31,74,31,74,30,245,31,231,31,231,30,185,31,239,31,109,31,41,31,103,31,212,31,146,31,146,30,137,31,196,31,56,31,87,31,153,31,58,31,58,30,146,31,251,31,178,31,29,31,167,31,43,31,128,31,131,31,106,31,80,31,6,31,253,31,219,31,40,31,192,31,135,31,158,31,158,30,10,31,3,31,175,31,131,31,131,30,131,29,96,31,49,31,64,31,80,31,100,31,49,31,19,31,234,31,72,31,46,31,173,31,249,31,162,31,162,30,185,31,94,31,243,31,9,31,81,31,102,31,102,30,113,31,249,31,92,31,43,31,30,31,95,31,95,30,198,31,70,31,70,30,144,31,232,31,232,30,1,31,47,31,77,31,164,31,15,31,170,31,147,31,147,30,148,31,134,31,134,30,225,31,248,31,226,31,53,31,53,30,93,31,229,31,154,31,154,30,31,31,82,31,145,31,213,31,33,31,229,31,81,31,23,31,23,30,106,31,106,31,235,31,66,31,126,31,244,31,244,30,229,31,196,31,85,31,238,31,238,30,234,31,114,31,98,31,98,30,243,31,243,30,212,31,8,31,8,30,58,31,58,30,109,31,170,31,43,31,231,31,75,31,184,31,184,30,234,31,234,30,203,31,169,31,97,31,97,30,131,31,131,30,147,31,160,31,217,31,240,31,124,31,123,31,123,30,123,29,50,31,28,31,28,30,66,31,66,30,124,31,97,31,117,31,198,31,72,31,72,30,31,31,192,31,186,31,157,31,157,30,226,31,165,31,163,31,2,31,116,31,116,30,122,31,45,31,239,31,151,31,71,31,71,30,71,29,71,28,91,31,99,31,177,31,183,31,183,30,199,31,112,31,156,31,166,31,169,31,169,30,247,31,247,30,205,31,197,31,69,31,207,31,68,31,68,30,68,29,230,31,26,31,5,31,5,30,5,29,154,31,134,31,222,31,203,31,53,31,150,31,150,30,31,31,253,31,253,30,253,29,253,28,253,27,67,31,49,31,49,30,194,31,194,30,194,31,194,30,174,31,174,30,173,31,193,31,123,31,123,30,118,31,220,31,220,30,194,31,234,31,234,30,85,31,6,31,91,31,104,31,226,31,240,31,247,31,191,31,52,31,236,31,148,31,147,31,147,30,122,31,101,31,101,30,91,31,186,31,90,31,238,31,238,30,238,29,238,28,174,31,242,31,215,31,207,31,207,30,75,31,238,31,124,31,78,31,251,31,29,31,203,31,203,30,202,31,120,31,210,31,142,31,218,31,218,30,29,31,55,31,55,30,244,31,1,31,93,31,185,31,185,30,96,31,195,31,33,31,62,31,15,31,15,30,184,31,254,31,159,31,162,31,62,31,220,31,220,30,21,31,197,31,64,31,39,31,71,31,71,30,132,31,67,31,67,30,191,31,68,31,108,31,108,30,6,31,80,31,162,31,202,31,33,31,33,30,122,31,116,31,116,30,222,31,222,30,136,31,161,31,130,31,199,31,199,30,182,31,182,30,182,29,140,31,40,31,50,31,150,31,232,31,232,30,232,29,137,31,55,31,165,31,90,31,3,31,38,31,38,30,137,31,137,31,137,30,105,31,7,31,86,31,1,31,1,30,7,31,88,31,10,31,4,31,4,30,235,31,203,31,45,31,68,31,68,30,145,31,145,30,96,31,174,31,174,30,59,31,27,31,173,31,59,31,179,31,254,31,153,31,73,31,73,30,42,31,107,31,188,31,199,31,79,31,61,31,111,31,211,31,19,31,28,31,221,31,192,31,46,31,32,31,24,31,119,31,222,31,182,31,28,31,28,30,28,29,112,31,112,30,151,31,215,31,72,31,72,30,239,31,198,31,114,31,208,31,187,31,174,31,160,31,230,31,210,31,169,31,89,31,24,31,165,31,48,31,90,31,89,31,89,30,89,29,89,28,242,31,73,31,73,30,12,31,254,31,83,31,83,30,138,31,157,31,157,30,199,31,24,31,123,31,86,31,83,31,8,31,123,31,137,31,137,30,165,31,92,31,92,30,179,31,49,31,87,31,87,30,87,29,227,31,238,31,147,31,147,30,147,29,147,28,84,31,84,30,209,31,83,31,50,31,244,31,99,31,172,31,214,31,67,31,223,31,90,31,117,31,84,31,221,31,221,30,125,31,157,31,3,31,204,31,125,31,117,31,211,31,112,31,2,31,2,30,2,29,122,31,21,31,3,31,10,31,3,31,56,31,172,31,214,31,94,31,18,31,18,30,15,31,223,31,239,31,2,31,2,30,139,31,10,31,216,31,132,31,2,31,67,31,67,30,231,31,28,31);

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
