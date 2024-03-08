-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_161 is
end project_tb_161;

architecture project_tb_arch_161 of project_tb_161 is
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

constant SCENARIO_LENGTH : integer := 705;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (1,0,184,0,102,0,208,0,246,0,180,0,169,0,246,0,3,0,113,0,190,0,0,0,177,0,0,0,59,0,176,0,40,0,216,0,0,0,89,0,109,0,222,0,246,0,0,0,44,0,201,0,105,0,44,0,210,0,177,0,205,0,0,0,184,0,8,0,0,0,14,0,78,0,221,0,120,0,77,0,27,0,0,0,72,0,154,0,139,0,0,0,13,0,0,0,55,0,71,0,69,0,201,0,199,0,25,0,0,0,131,0,0,0,9,0,72,0,0,0,83,0,158,0,94,0,50,0,112,0,3,0,115,0,77,0,0,0,33,0,160,0,42,0,110,0,0,0,0,0,215,0,145,0,192,0,114,0,0,0,0,0,0,0,231,0,188,0,34,0,185,0,153,0,12,0,156,0,0,0,41,0,144,0,45,0,42,0,0,0,71,0,11,0,0,0,144,0,186,0,0,0,0,0,146,0,131,0,0,0,50,0,5,0,0,0,208,0,4,0,87,0,121,0,224,0,253,0,0,0,214,0,216,0,16,0,0,0,63,0,167,0,0,0,228,0,255,0,213,0,223,0,158,0,142,0,140,0,183,0,28,0,108,0,74,0,0,0,118,0,249,0,31,0,72,0,97,0,8,0,4,0,248,0,81,0,151,0,237,0,69,0,0,0,194,0,50,0,0,0,187,0,0,0,10,0,203,0,15,0,49,0,46,0,170,0,0,0,147,0,205,0,215,0,98,0,197,0,55,0,0,0,134,0,0,0,104,0,141,0,135,0,152,0,5,0,192,0,27,0,144,0,9,0,110,0,14,0,193,0,21,0,251,0,0,0,0,0,63,0,173,0,44,0,136,0,229,0,117,0,58,0,8,0,234,0,151,0,44,0,210,0,0,0,0,0,0,0,213,0,85,0,25,0,148,0,34,0,69,0,40,0,201,0,7,0,231,0,253,0,149,0,129,0,94,0,0,0,169,0,142,0,76,0,0,0,189,0,244,0,199,0,0,0,73,0,100,0,254,0,0,0,223,0,73,0,251,0,137,0,91,0,9,0,0,0,0,0,78,0,62,0,51,0,193,0,53,0,103,0,12,0,117,0,53,0,47,0,248,0,24,0,152,0,215,0,223,0,7,0,137,0,171,0,103,0,101,0,23,0,154,0,3,0,182,0,211,0,137,0,216,0,105,0,121,0,136,0,25,0,98,0,0,0,194,0,196,0,0,0,53,0,175,0,152,0,5,0,98,0,0,0,32,0,199,0,165,0,175,0,212,0,203,0,0,0,0,0,152,0,169,0,37,0,11,0,143,0,223,0,148,0,242,0,76,0,142,0,152,0,0,0,156,0,195,0,46,0,28,0,59,0,197,0,85,0,0,0,246,0,48,0,252,0,94,0,91,0,60,0,249,0,13,0,189,0,0,0,127,0,7,0,0,0,44,0,215,0,186,0,138,0,233,0,0,0,44,0,105,0,157,0,91,0,229,0,186,0,50,0,30,0,0,0,248,0,151,0,132,0,48,0,247,0,11,0,69,0,0,0,143,0,0,0,220,0,81,0,0,0,236,0,0,0,150,0,243,0,188,0,0,0,147,0,0,0,0,0,0,0,230,0,0,0,129,0,0,0,223,0,0,0,210,0,153,0,108,0,0,0,0,0,94,0,230,0,182,0,172,0,144,0,158,0,31,0,254,0,32,0,192,0,18,0,34,0,214,0,183,0,192,0,120,0,4,0,137,0,0,0,209,0,30,0,0,0,204,0,155,0,235,0,66,0,241,0,143,0,22,0,0,0,94,0,116,0,107,0,117,0,1,0,56,0,30,0,73,0,108,0,75,0,104,0,136,0,40,0,48,0,173,0,0,0,32,0,33,0,86,0,165,0,95,0,243,0,0,0,85,0,113,0,0,0,19,0,181,0,32,0,78,0,78,0,76,0,128,0,40,0,135,0,194,0,38,0,163,0,16,0,237,0,170,0,39,0,175,0,240,0,58,0,0,0,52,0,182,0,96,0,131,0,72,0,0,0,146,0,52,0,6,0,243,0,0,0,210,0,111,0,4,0,108,0,1,0,0,0,143,0,189,0,0,0,231,0,76,0,133,0,0,0,125,0,46,0,155,0,51,0,89,0,105,0,254,0,195,0,36,0,120,0,194,0,0,0,112,0,84,0,0,0,17,0,190,0,42,0,26,0,47,0,0,0,207,0,21,0,149,0,253,0,0,0,0,0,234,0,62,0,237,0,0,0,135,0,186,0,155,0,192,0,176,0,0,0,206,0,162,0,0,0,0,0,228,0,126,0,141,0,0,0,0,0,18,0,9,0,0,0,0,0,0,0,0,0,163,0,180,0,114,0,82,0,115,0,241,0,162,0,0,0,0,0,199,0,187,0,0,0,35,0,0,0,37,0,12,0,176,0,173,0,182,0,192,0,0,0,0,0,27,0,26,0,211,0,188,0,148,0,106,0,181,0,184,0,177,0,8,0,54,0,0,0,124,0,156,0,36,0,0,0,23,0,143,0,110,0,195,0,0,0,0,0,0,0,191,0,77,0,210,0,92,0,93,0,0,0,156,0,250,0,36,0,61,0,199,0,48,0,132,0,86,0,128,0,207,0,84,0,56,0,222,0,186,0,182,0,0,0,161,0,50,0,216,0,221,0,0,0,0,0,90,0,195,0,222,0,42,0,91,0,213,0,0,0,235,0,64,0,41,0,26,0,205,0,196,0,56,0,0,0,78,0,45,0,12,0,187,0,227,0,113,0,223,0,131,0,162,0,104,0,164,0,0,0,83,0,201,0,121,0,187,0,39,0,97,0,174,0,86,0,66,0,20,0,100,0,170,0,70,0,24,0,0,0,21,0,15,0,126,0,252,0,25,0,92,0,0,0,13,0,89,0,225,0,160,0,18,0,28,0,185,0,5,0,75,0,19,0,236,0,138,0,71,0,187,0,158,0,243,0,56,0,23,0,84,0,126,0,0,0,215,0,87,0,211,0,99,0,32,0,201,0,219,0,0,0,0,0,0,0,255,0,237,0,87,0,214,0,234,0,82,0,197,0,202,0,158,0,130,0,97,0,171,0,193,0,214,0,243,0,71,0,0,0,134,0,169,0,215,0,215,0,141,0,0,0,0,0,160,0,101,0,0,0,0,0,171,0,0,0,64,0,0,0,137,0,13,0);
signal scenario_full  : scenario_type := (1,31,184,31,102,31,208,31,246,31,180,31,169,31,246,31,3,31,113,31,190,31,190,30,177,31,177,30,59,31,176,31,40,31,216,31,216,30,89,31,109,31,222,31,246,31,246,30,44,31,201,31,105,31,44,31,210,31,177,31,205,31,205,30,184,31,8,31,8,30,14,31,78,31,221,31,120,31,77,31,27,31,27,30,72,31,154,31,139,31,139,30,13,31,13,30,55,31,71,31,69,31,201,31,199,31,25,31,25,30,131,31,131,30,9,31,72,31,72,30,83,31,158,31,94,31,50,31,112,31,3,31,115,31,77,31,77,30,33,31,160,31,42,31,110,31,110,30,110,29,215,31,145,31,192,31,114,31,114,30,114,29,114,28,231,31,188,31,34,31,185,31,153,31,12,31,156,31,156,30,41,31,144,31,45,31,42,31,42,30,71,31,11,31,11,30,144,31,186,31,186,30,186,29,146,31,131,31,131,30,50,31,5,31,5,30,208,31,4,31,87,31,121,31,224,31,253,31,253,30,214,31,216,31,16,31,16,30,63,31,167,31,167,30,228,31,255,31,213,31,223,31,158,31,142,31,140,31,183,31,28,31,108,31,74,31,74,30,118,31,249,31,31,31,72,31,97,31,8,31,4,31,248,31,81,31,151,31,237,31,69,31,69,30,194,31,50,31,50,30,187,31,187,30,10,31,203,31,15,31,49,31,46,31,170,31,170,30,147,31,205,31,215,31,98,31,197,31,55,31,55,30,134,31,134,30,104,31,141,31,135,31,152,31,5,31,192,31,27,31,144,31,9,31,110,31,14,31,193,31,21,31,251,31,251,30,251,29,63,31,173,31,44,31,136,31,229,31,117,31,58,31,8,31,234,31,151,31,44,31,210,31,210,30,210,29,210,28,213,31,85,31,25,31,148,31,34,31,69,31,40,31,201,31,7,31,231,31,253,31,149,31,129,31,94,31,94,30,169,31,142,31,76,31,76,30,189,31,244,31,199,31,199,30,73,31,100,31,254,31,254,30,223,31,73,31,251,31,137,31,91,31,9,31,9,30,9,29,78,31,62,31,51,31,193,31,53,31,103,31,12,31,117,31,53,31,47,31,248,31,24,31,152,31,215,31,223,31,7,31,137,31,171,31,103,31,101,31,23,31,154,31,3,31,182,31,211,31,137,31,216,31,105,31,121,31,136,31,25,31,98,31,98,30,194,31,196,31,196,30,53,31,175,31,152,31,5,31,98,31,98,30,32,31,199,31,165,31,175,31,212,31,203,31,203,30,203,29,152,31,169,31,37,31,11,31,143,31,223,31,148,31,242,31,76,31,142,31,152,31,152,30,156,31,195,31,46,31,28,31,59,31,197,31,85,31,85,30,246,31,48,31,252,31,94,31,91,31,60,31,249,31,13,31,189,31,189,30,127,31,7,31,7,30,44,31,215,31,186,31,138,31,233,31,233,30,44,31,105,31,157,31,91,31,229,31,186,31,50,31,30,31,30,30,248,31,151,31,132,31,48,31,247,31,11,31,69,31,69,30,143,31,143,30,220,31,81,31,81,30,236,31,236,30,150,31,243,31,188,31,188,30,147,31,147,30,147,29,147,28,230,31,230,30,129,31,129,30,223,31,223,30,210,31,153,31,108,31,108,30,108,29,94,31,230,31,182,31,172,31,144,31,158,31,31,31,254,31,32,31,192,31,18,31,34,31,214,31,183,31,192,31,120,31,4,31,137,31,137,30,209,31,30,31,30,30,204,31,155,31,235,31,66,31,241,31,143,31,22,31,22,30,94,31,116,31,107,31,117,31,1,31,56,31,30,31,73,31,108,31,75,31,104,31,136,31,40,31,48,31,173,31,173,30,32,31,33,31,86,31,165,31,95,31,243,31,243,30,85,31,113,31,113,30,19,31,181,31,32,31,78,31,78,31,76,31,128,31,40,31,135,31,194,31,38,31,163,31,16,31,237,31,170,31,39,31,175,31,240,31,58,31,58,30,52,31,182,31,96,31,131,31,72,31,72,30,146,31,52,31,6,31,243,31,243,30,210,31,111,31,4,31,108,31,1,31,1,30,143,31,189,31,189,30,231,31,76,31,133,31,133,30,125,31,46,31,155,31,51,31,89,31,105,31,254,31,195,31,36,31,120,31,194,31,194,30,112,31,84,31,84,30,17,31,190,31,42,31,26,31,47,31,47,30,207,31,21,31,149,31,253,31,253,30,253,29,234,31,62,31,237,31,237,30,135,31,186,31,155,31,192,31,176,31,176,30,206,31,162,31,162,30,162,29,228,31,126,31,141,31,141,30,141,29,18,31,9,31,9,30,9,29,9,28,9,27,163,31,180,31,114,31,82,31,115,31,241,31,162,31,162,30,162,29,199,31,187,31,187,30,35,31,35,30,37,31,12,31,176,31,173,31,182,31,192,31,192,30,192,29,27,31,26,31,211,31,188,31,148,31,106,31,181,31,184,31,177,31,8,31,54,31,54,30,124,31,156,31,36,31,36,30,23,31,143,31,110,31,195,31,195,30,195,29,195,28,191,31,77,31,210,31,92,31,93,31,93,30,156,31,250,31,36,31,61,31,199,31,48,31,132,31,86,31,128,31,207,31,84,31,56,31,222,31,186,31,182,31,182,30,161,31,50,31,216,31,221,31,221,30,221,29,90,31,195,31,222,31,42,31,91,31,213,31,213,30,235,31,64,31,41,31,26,31,205,31,196,31,56,31,56,30,78,31,45,31,12,31,187,31,227,31,113,31,223,31,131,31,162,31,104,31,164,31,164,30,83,31,201,31,121,31,187,31,39,31,97,31,174,31,86,31,66,31,20,31,100,31,170,31,70,31,24,31,24,30,21,31,15,31,126,31,252,31,25,31,92,31,92,30,13,31,89,31,225,31,160,31,18,31,28,31,185,31,5,31,75,31,19,31,236,31,138,31,71,31,187,31,158,31,243,31,56,31,23,31,84,31,126,31,126,30,215,31,87,31,211,31,99,31,32,31,201,31,219,31,219,30,219,29,219,28,255,31,237,31,87,31,214,31,234,31,82,31,197,31,202,31,158,31,130,31,97,31,171,31,193,31,214,31,243,31,71,31,71,30,134,31,169,31,215,31,215,31,141,31,141,30,141,29,160,31,101,31,101,30,101,29,171,31,171,30,64,31,64,30,137,31,13,31);

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
