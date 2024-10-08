-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_937 is
end project_tb_937;

architecture project_tb_arch_937 of project_tb_937 is
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

constant SCENARIO_LENGTH : integer := 438;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (61,0,0,0,204,0,33,0,215,0,37,0,193,0,241,0,160,0,138,0,208,0,158,0,114,0,207,0,240,0,69,0,151,0,102,0,148,0,41,0,157,0,8,0,236,0,176,0,0,0,2,0,112,0,0,0,162,0,0,0,187,0,87,0,103,0,218,0,73,0,253,0,197,0,28,0,213,0,12,0,25,0,88,0,47,0,234,0,0,0,0,0,161,0,0,0,0,0,190,0,215,0,127,0,127,0,62,0,98,0,221,0,0,0,140,0,0,0,157,0,124,0,110,0,130,0,249,0,25,0,65,0,214,0,231,0,29,0,215,0,215,0,224,0,244,0,185,0,194,0,147,0,25,0,0,0,0,0,86,0,76,0,0,0,14,0,195,0,9,0,181,0,181,0,145,0,33,0,248,0,189,0,228,0,170,0,135,0,221,0,82,0,234,0,0,0,225,0,110,0,255,0,228,0,157,0,62,0,28,0,74,0,0,0,0,0,31,0,114,0,166,0,94,0,225,0,91,0,0,0,193,0,164,0,125,0,198,0,154,0,224,0,223,0,206,0,0,0,238,0,0,0,37,0,229,0,162,0,21,0,0,0,228,0,165,0,143,0,91,0,77,0,245,0,78,0,165,0,0,0,0,0,158,0,100,0,173,0,218,0,120,0,212,0,96,0,216,0,59,0,0,0,140,0,220,0,43,0,49,0,24,0,0,0,26,0,192,0,84,0,245,0,175,0,204,0,132,0,59,0,183,0,97,0,120,0,0,0,194,0,174,0,74,0,157,0,0,0,4,0,38,0,99,0,0,0,0,0,18,0,0,0,0,0,114,0,179,0,243,0,217,0,66,0,53,0,238,0,0,0,199,0,219,0,24,0,0,0,134,0,179,0,122,0,190,0,222,0,0,0,0,0,114,0,87,0,218,0,195,0,246,0,229,0,61,0,125,0,219,0,221,0,0,0,57,0,117,0,113,0,0,0,0,0,114,0,132,0,10,0,127,0,0,0,0,0,172,0,0,0,0,0,218,0,5,0,163,0,164,0,36,0,105,0,63,0,218,0,246,0,91,0,84,0,173,0,0,0,201,0,45,0,137,0,55,0,0,0,2,0,119,0,25,0,59,0,194,0,32,0,56,0,195,0,74,0,87,0,47,0,0,0,228,0,0,0,198,0,100,0,0,0,58,0,43,0,88,0,209,0,121,0,243,0,251,0,19,0,99,0,241,0,0,0,0,0,0,0,166,0,68,0,224,0,36,0,0,0,26,0,129,0,0,0,48,0,230,0,88,0,80,0,0,0,153,0,224,0,56,0,42,0,0,0,212,0,0,0,235,0,0,0,176,0,153,0,114,0,161,0,186,0,0,0,60,0,245,0,222,0,93,0,179,0,147,0,189,0,153,0,244,0,0,0,114,0,217,0,0,0,1,0,0,0,204,0,194,0,0,0,233,0,0,0,251,0,230,0,0,0,31,0,161,0,0,0,30,0,183,0,132,0,127,0,0,0,17,0,0,0,204,0,0,0,2,0,207,0,208,0,105,0,166,0,172,0,239,0,227,0,151,0,255,0,173,0,170,0,211,0,0,0,120,0,0,0,191,0,112,0,0,0,0,0,144,0,183,0,136,0,20,0,38,0,221,0,0,0,252,0,73,0,0,0,197,0,4,0,252,0,0,0,0,0,88,0,237,0,10,0,227,0,173,0,172,0,186,0,128,0,74,0,95,0,45,0,58,0,0,0,0,0,65,0,181,0,188,0,0,0,0,0,113,0,7,0,0,0,0,0,117,0,0,0,0,0,0,0,0,0,100,0,222,0,145,0,4,0,217,0,151,0,149,0,234,0,21,0,0,0,41,0,151,0,86,0,0,0,0,0,16,0,111,0,8,0,200,0,196,0,172,0,169,0,0,0,160,0,228,0,125,0,0,0,50,0,36,0,0,0,113,0,0,0,101,0,232,0,78,0,94,0,225,0,0,0);
signal scenario_full  : scenario_type := (61,31,61,30,204,31,33,31,215,31,37,31,193,31,241,31,160,31,138,31,208,31,158,31,114,31,207,31,240,31,69,31,151,31,102,31,148,31,41,31,157,31,8,31,236,31,176,31,176,30,2,31,112,31,112,30,162,31,162,30,187,31,87,31,103,31,218,31,73,31,253,31,197,31,28,31,213,31,12,31,25,31,88,31,47,31,234,31,234,30,234,29,161,31,161,30,161,29,190,31,215,31,127,31,127,31,62,31,98,31,221,31,221,30,140,31,140,30,157,31,124,31,110,31,130,31,249,31,25,31,65,31,214,31,231,31,29,31,215,31,215,31,224,31,244,31,185,31,194,31,147,31,25,31,25,30,25,29,86,31,76,31,76,30,14,31,195,31,9,31,181,31,181,31,145,31,33,31,248,31,189,31,228,31,170,31,135,31,221,31,82,31,234,31,234,30,225,31,110,31,255,31,228,31,157,31,62,31,28,31,74,31,74,30,74,29,31,31,114,31,166,31,94,31,225,31,91,31,91,30,193,31,164,31,125,31,198,31,154,31,224,31,223,31,206,31,206,30,238,31,238,30,37,31,229,31,162,31,21,31,21,30,228,31,165,31,143,31,91,31,77,31,245,31,78,31,165,31,165,30,165,29,158,31,100,31,173,31,218,31,120,31,212,31,96,31,216,31,59,31,59,30,140,31,220,31,43,31,49,31,24,31,24,30,26,31,192,31,84,31,245,31,175,31,204,31,132,31,59,31,183,31,97,31,120,31,120,30,194,31,174,31,74,31,157,31,157,30,4,31,38,31,99,31,99,30,99,29,18,31,18,30,18,29,114,31,179,31,243,31,217,31,66,31,53,31,238,31,238,30,199,31,219,31,24,31,24,30,134,31,179,31,122,31,190,31,222,31,222,30,222,29,114,31,87,31,218,31,195,31,246,31,229,31,61,31,125,31,219,31,221,31,221,30,57,31,117,31,113,31,113,30,113,29,114,31,132,31,10,31,127,31,127,30,127,29,172,31,172,30,172,29,218,31,5,31,163,31,164,31,36,31,105,31,63,31,218,31,246,31,91,31,84,31,173,31,173,30,201,31,45,31,137,31,55,31,55,30,2,31,119,31,25,31,59,31,194,31,32,31,56,31,195,31,74,31,87,31,47,31,47,30,228,31,228,30,198,31,100,31,100,30,58,31,43,31,88,31,209,31,121,31,243,31,251,31,19,31,99,31,241,31,241,30,241,29,241,28,166,31,68,31,224,31,36,31,36,30,26,31,129,31,129,30,48,31,230,31,88,31,80,31,80,30,153,31,224,31,56,31,42,31,42,30,212,31,212,30,235,31,235,30,176,31,153,31,114,31,161,31,186,31,186,30,60,31,245,31,222,31,93,31,179,31,147,31,189,31,153,31,244,31,244,30,114,31,217,31,217,30,1,31,1,30,204,31,194,31,194,30,233,31,233,30,251,31,230,31,230,30,31,31,161,31,161,30,30,31,183,31,132,31,127,31,127,30,17,31,17,30,204,31,204,30,2,31,207,31,208,31,105,31,166,31,172,31,239,31,227,31,151,31,255,31,173,31,170,31,211,31,211,30,120,31,120,30,191,31,112,31,112,30,112,29,144,31,183,31,136,31,20,31,38,31,221,31,221,30,252,31,73,31,73,30,197,31,4,31,252,31,252,30,252,29,88,31,237,31,10,31,227,31,173,31,172,31,186,31,128,31,74,31,95,31,45,31,58,31,58,30,58,29,65,31,181,31,188,31,188,30,188,29,113,31,7,31,7,30,7,29,117,31,117,30,117,29,117,28,117,27,100,31,222,31,145,31,4,31,217,31,151,31,149,31,234,31,21,31,21,30,41,31,151,31,86,31,86,30,86,29,16,31,111,31,8,31,200,31,196,31,172,31,169,31,169,30,160,31,228,31,125,31,125,30,50,31,36,31,36,30,113,31,113,30,101,31,232,31,78,31,94,31,225,31,225,30);

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
