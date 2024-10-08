-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_987 is
end project_tb_987;

architecture project_tb_arch_987 of project_tb_987 is
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

constant SCENARIO_LENGTH : integer := 697;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (218,0,111,0,255,0,147,0,232,0,139,0,17,0,118,0,199,0,1,0,47,0,75,0,139,0,134,0,63,0,100,0,215,0,124,0,149,0,0,0,198,0,47,0,0,0,212,0,11,0,237,0,86,0,60,0,73,0,185,0,226,0,206,0,57,0,129,0,0,0,196,0,101,0,240,0,0,0,50,0,124,0,114,0,200,0,183,0,22,0,0,0,245,0,169,0,29,0,0,0,7,0,0,0,205,0,71,0,242,0,193,0,126,0,24,0,107,0,180,0,163,0,204,0,161,0,143,0,0,0,250,0,2,0,17,0,183,0,0,0,109,0,67,0,64,0,110,0,0,0,9,0,0,0,180,0,227,0,11,0,0,0,136,0,187,0,172,0,29,0,67,0,0,0,144,0,249,0,198,0,169,0,0,0,108,0,173,0,18,0,87,0,12,0,245,0,0,0,238,0,128,0,98,0,201,0,100,0,0,0,3,0,6,0,185,0,47,0,209,0,0,0,0,0,88,0,89,0,0,0,0,0,0,0,52,0,115,0,71,0,0,0,191,0,183,0,78,0,10,0,26,0,205,0,233,0,32,0,33,0,0,0,143,0,148,0,115,0,221,0,0,0,0,0,0,0,9,0,0,0,96,0,142,0,0,0,157,0,123,0,0,0,74,0,0,0,121,0,107,0,23,0,68,0,0,0,108,0,0,0,93,0,0,0,126,0,215,0,39,0,0,0,241,0,43,0,127,0,96,0,0,0,6,0,0,0,0,0,0,0,8,0,9,0,0,0,12,0,165,0,219,0,195,0,90,0,172,0,0,0,0,0,235,0,41,0,216,0,254,0,0,0,246,0,93,0,194,0,145,0,0,0,0,0,85,0,110,0,195,0,25,0,3,0,90,0,207,0,254,0,31,0,111,0,147,0,167,0,43,0,13,0,230,0,0,0,54,0,10,0,0,0,130,0,27,0,208,0,130,0,197,0,208,0,102,0,53,0,102,0,0,0,251,0,0,0,17,0,0,0,198,0,0,0,113,0,0,0,4,0,167,0,0,0,55,0,170,0,169,0,229,0,13,0,134,0,32,0,0,0,91,0,253,0,34,0,129,0,0,0,22,0,140,0,215,0,213,0,0,0,27,0,0,0,13,0,248,0,0,0,55,0,123,0,0,0,146,0,221,0,89,0,114,0,141,0,63,0,33,0,222,0,0,0,50,0,0,0,191,0,250,0,160,0,0,0,126,0,251,0,22,0,1,0,135,0,108,0,0,0,105,0,10,0,55,0,44,0,3,0,239,0,173,0,0,0,22,0,27,0,132,0,231,0,86,0,99,0,187,0,77,0,0,0,194,0,67,0,159,0,0,0,230,0,181,0,163,0,24,0,64,0,101,0,135,0,0,0,67,0,255,0,137,0,86,0,180,0,156,0,183,0,97,0,10,0,160,0,18,0,62,0,213,0,32,0,0,0,239,0,7,0,142,0,135,0,221,0,129,0,0,0,71,0,40,0,147,0,10,0,174,0,199,0,157,0,201,0,91,0,194,0,134,0,220,0,129,0,226,0,75,0,207,0,0,0,2,0,77,0,45,0,5,0,0,0,85,0,124,0,0,0,233,0,1,0,234,0,0,0,0,0,254,0,238,0,119,0,35,0,207,0,118,0,202,0,130,0,58,0,40,0,216,0,206,0,8,0,105,0,202,0,213,0,23,0,0,0,146,0,0,0,47,0,105,0,109,0,110,0,240,0,8,0,234,0,16,0,117,0,0,0,57,0,126,0,254,0,192,0,131,0,225,0,31,0,120,0,253,0,28,0,138,0,174,0,135,0,175,0,147,0,168,0,201,0,226,0,165,0,232,0,235,0,17,0,117,0,33,0,244,0,229,0,163,0,0,0,0,0,0,0,110,0,0,0,211,0,58,0,109,0,161,0,199,0,79,0,254,0,144,0,0,0,47,0,0,0,67,0,0,0,213,0,150,0,161,0,191,0,28,0,0,0,0,0,0,0,3,0,69,0,159,0,179,0,51,0,45,0,56,0,38,0,55,0,0,0,34,0,45,0,237,0,179,0,65,0,31,0,222,0,217,0,110,0,94,0,47,0,13,0,223,0,142,0,86,0,218,0,0,0,248,0,122,0,54,0,152,0,200,0,9,0,129,0,228,0,0,0,186,0,0,0,223,0,96,0,29,0,0,0,223,0,12,0,213,0,234,0,74,0,93,0,0,0,9,0,219,0,25,0,218,0,182,0,173,0,235,0,107,0,169,0,45,0,0,0,66,0,0,0,242,0,0,0,209,0,0,0,221,0,105,0,187,0,88,0,236,0,188,0,29,0,236,0,221,0,0,0,175,0,0,0,157,0,0,0,1,0,0,0,178,0,31,0,124,0,115,0,178,0,232,0,114,0,0,0,0,0,178,0,221,0,13,0,0,0,104,0,243,0,0,0,98,0,241,0,0,0,0,0,102,0,0,0,193,0,107,0,218,0,138,0,65,0,108,0,219,0,0,0,48,0,219,0,27,0,0,0,0,0,0,0,98,0,0,0,0,0,0,0,139,0,0,0,5,0,23,0,170,0,227,0,7,0,78,0,130,0,139,0,13,0,185,0,0,0,215,0,0,0,172,0,0,0,43,0,8,0,222,0,179,0,216,0,115,0,119,0,184,0,213,0,195,0,193,0,221,0,205,0,35,0,0,0,220,0,67,0,200,0,143,0,98,0,56,0,32,0,0,0,26,0,102,0,198,0,252,0,0,0,149,0,116,0,190,0,130,0,54,0,117,0,217,0,162,0,144,0,0,0,214,0,252,0,174,0,150,0,0,0,37,0,28,0,78,0,37,0,0,0,150,0,0,0,0,0,0,0,148,0,133,0,144,0,52,0,108,0,117,0,0,0,138,0,245,0,172,0,204,0,0,0,59,0,0,0,5,0,37,0,0,0,0,0,7,0,0,0,10,0,0,0,0,0,200,0,131,0,171,0,95,0,21,0,179,0,181,0,0,0,13,0,180,0,136,0,154,0,219,0,167,0,44,0,248,0,98,0,171,0,43,0,182,0,135,0,52,0,88,0,45,0,67,0,170,0,146,0,0,0,48,0,114,0,17,0,0,0,0,0,75,0,220,0,186,0,194,0,0,0,212,0);
signal scenario_full  : scenario_type := (218,31,111,31,255,31,147,31,232,31,139,31,17,31,118,31,199,31,1,31,47,31,75,31,139,31,134,31,63,31,100,31,215,31,124,31,149,31,149,30,198,31,47,31,47,30,212,31,11,31,237,31,86,31,60,31,73,31,185,31,226,31,206,31,57,31,129,31,129,30,196,31,101,31,240,31,240,30,50,31,124,31,114,31,200,31,183,31,22,31,22,30,245,31,169,31,29,31,29,30,7,31,7,30,205,31,71,31,242,31,193,31,126,31,24,31,107,31,180,31,163,31,204,31,161,31,143,31,143,30,250,31,2,31,17,31,183,31,183,30,109,31,67,31,64,31,110,31,110,30,9,31,9,30,180,31,227,31,11,31,11,30,136,31,187,31,172,31,29,31,67,31,67,30,144,31,249,31,198,31,169,31,169,30,108,31,173,31,18,31,87,31,12,31,245,31,245,30,238,31,128,31,98,31,201,31,100,31,100,30,3,31,6,31,185,31,47,31,209,31,209,30,209,29,88,31,89,31,89,30,89,29,89,28,52,31,115,31,71,31,71,30,191,31,183,31,78,31,10,31,26,31,205,31,233,31,32,31,33,31,33,30,143,31,148,31,115,31,221,31,221,30,221,29,221,28,9,31,9,30,96,31,142,31,142,30,157,31,123,31,123,30,74,31,74,30,121,31,107,31,23,31,68,31,68,30,108,31,108,30,93,31,93,30,126,31,215,31,39,31,39,30,241,31,43,31,127,31,96,31,96,30,6,31,6,30,6,29,6,28,8,31,9,31,9,30,12,31,165,31,219,31,195,31,90,31,172,31,172,30,172,29,235,31,41,31,216,31,254,31,254,30,246,31,93,31,194,31,145,31,145,30,145,29,85,31,110,31,195,31,25,31,3,31,90,31,207,31,254,31,31,31,111,31,147,31,167,31,43,31,13,31,230,31,230,30,54,31,10,31,10,30,130,31,27,31,208,31,130,31,197,31,208,31,102,31,53,31,102,31,102,30,251,31,251,30,17,31,17,30,198,31,198,30,113,31,113,30,4,31,167,31,167,30,55,31,170,31,169,31,229,31,13,31,134,31,32,31,32,30,91,31,253,31,34,31,129,31,129,30,22,31,140,31,215,31,213,31,213,30,27,31,27,30,13,31,248,31,248,30,55,31,123,31,123,30,146,31,221,31,89,31,114,31,141,31,63,31,33,31,222,31,222,30,50,31,50,30,191,31,250,31,160,31,160,30,126,31,251,31,22,31,1,31,135,31,108,31,108,30,105,31,10,31,55,31,44,31,3,31,239,31,173,31,173,30,22,31,27,31,132,31,231,31,86,31,99,31,187,31,77,31,77,30,194,31,67,31,159,31,159,30,230,31,181,31,163,31,24,31,64,31,101,31,135,31,135,30,67,31,255,31,137,31,86,31,180,31,156,31,183,31,97,31,10,31,160,31,18,31,62,31,213,31,32,31,32,30,239,31,7,31,142,31,135,31,221,31,129,31,129,30,71,31,40,31,147,31,10,31,174,31,199,31,157,31,201,31,91,31,194,31,134,31,220,31,129,31,226,31,75,31,207,31,207,30,2,31,77,31,45,31,5,31,5,30,85,31,124,31,124,30,233,31,1,31,234,31,234,30,234,29,254,31,238,31,119,31,35,31,207,31,118,31,202,31,130,31,58,31,40,31,216,31,206,31,8,31,105,31,202,31,213,31,23,31,23,30,146,31,146,30,47,31,105,31,109,31,110,31,240,31,8,31,234,31,16,31,117,31,117,30,57,31,126,31,254,31,192,31,131,31,225,31,31,31,120,31,253,31,28,31,138,31,174,31,135,31,175,31,147,31,168,31,201,31,226,31,165,31,232,31,235,31,17,31,117,31,33,31,244,31,229,31,163,31,163,30,163,29,163,28,110,31,110,30,211,31,58,31,109,31,161,31,199,31,79,31,254,31,144,31,144,30,47,31,47,30,67,31,67,30,213,31,150,31,161,31,191,31,28,31,28,30,28,29,28,28,3,31,69,31,159,31,179,31,51,31,45,31,56,31,38,31,55,31,55,30,34,31,45,31,237,31,179,31,65,31,31,31,222,31,217,31,110,31,94,31,47,31,13,31,223,31,142,31,86,31,218,31,218,30,248,31,122,31,54,31,152,31,200,31,9,31,129,31,228,31,228,30,186,31,186,30,223,31,96,31,29,31,29,30,223,31,12,31,213,31,234,31,74,31,93,31,93,30,9,31,219,31,25,31,218,31,182,31,173,31,235,31,107,31,169,31,45,31,45,30,66,31,66,30,242,31,242,30,209,31,209,30,221,31,105,31,187,31,88,31,236,31,188,31,29,31,236,31,221,31,221,30,175,31,175,30,157,31,157,30,1,31,1,30,178,31,31,31,124,31,115,31,178,31,232,31,114,31,114,30,114,29,178,31,221,31,13,31,13,30,104,31,243,31,243,30,98,31,241,31,241,30,241,29,102,31,102,30,193,31,107,31,218,31,138,31,65,31,108,31,219,31,219,30,48,31,219,31,27,31,27,30,27,29,27,28,98,31,98,30,98,29,98,28,139,31,139,30,5,31,23,31,170,31,227,31,7,31,78,31,130,31,139,31,13,31,185,31,185,30,215,31,215,30,172,31,172,30,43,31,8,31,222,31,179,31,216,31,115,31,119,31,184,31,213,31,195,31,193,31,221,31,205,31,35,31,35,30,220,31,67,31,200,31,143,31,98,31,56,31,32,31,32,30,26,31,102,31,198,31,252,31,252,30,149,31,116,31,190,31,130,31,54,31,117,31,217,31,162,31,144,31,144,30,214,31,252,31,174,31,150,31,150,30,37,31,28,31,78,31,37,31,37,30,150,31,150,30,150,29,150,28,148,31,133,31,144,31,52,31,108,31,117,31,117,30,138,31,245,31,172,31,204,31,204,30,59,31,59,30,5,31,37,31,37,30,37,29,7,31,7,30,10,31,10,30,10,29,200,31,131,31,171,31,95,31,21,31,179,31,181,31,181,30,13,31,180,31,136,31,154,31,219,31,167,31,44,31,248,31,98,31,171,31,43,31,182,31,135,31,52,31,88,31,45,31,67,31,170,31,146,31,146,30,48,31,114,31,17,31,17,30,17,29,75,31,220,31,186,31,194,31,194,30,212,31);

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
