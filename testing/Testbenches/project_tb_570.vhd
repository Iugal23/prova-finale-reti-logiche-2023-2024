-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_570 is
end project_tb_570;

architecture project_tb_arch_570 of project_tb_570 is
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

constant SCENARIO_LENGTH : integer := 472;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (50,0,98,0,27,0,188,0,0,0,0,0,0,0,52,0,107,0,252,0,0,0,120,0,78,0,141,0,186,0,38,0,134,0,106,0,222,0,0,0,194,0,82,0,123,0,62,0,111,0,122,0,74,0,2,0,116,0,0,0,66,0,153,0,194,0,251,0,243,0,181,0,0,0,0,0,230,0,0,0,42,0,0,0,55,0,85,0,0,0,64,0,0,0,47,0,77,0,153,0,118,0,190,0,222,0,196,0,226,0,59,0,0,0,125,0,5,0,90,0,239,0,90,0,188,0,43,0,69,0,165,0,122,0,49,0,138,0,0,0,0,0,149,0,190,0,177,0,181,0,13,0,0,0,0,0,40,0,149,0,111,0,131,0,254,0,0,0,48,0,223,0,214,0,188,0,22,0,163,0,242,0,174,0,179,0,85,0,168,0,87,0,182,0,176,0,159,0,173,0,250,0,0,0,76,0,208,0,90,0,0,0,162,0,101,0,0,0,166,0,161,0,208,0,0,0,193,0,122,0,166,0,84,0,79,0,232,0,0,0,107,0,0,0,0,0,62,0,0,0,201,0,125,0,0,0,247,0,75,0,60,0,77,0,160,0,28,0,116,0,0,0,60,0,250,0,134,0,105,0,8,0,0,0,215,0,237,0,219,0,248,0,48,0,230,0,101,0,151,0,0,0,6,0,255,0,0,0,10,0,214,0,213,0,83,0,159,0,157,0,163,0,0,0,88,0,111,0,14,0,4,0,0,0,130,0,126,0,76,0,143,0,214,0,0,0,164,0,72,0,0,0,0,0,191,0,0,0,0,0,0,0,173,0,108,0,142,0,158,0,95,0,0,0,0,0,16,0,198,0,194,0,0,0,72,0,0,0,53,0,195,0,87,0,177,0,240,0,225,0,111,0,0,0,0,0,234,0,153,0,178,0,180,0,0,0,57,0,166,0,126,0,199,0,0,0,162,0,81,0,179,0,0,0,20,0,250,0,0,0,177,0,0,0,105,0,0,0,90,0,241,0,93,0,52,0,221,0,250,0,78,0,249,0,0,0,251,0,79,0,241,0,0,0,3,0,226,0,141,0,251,0,136,0,110,0,0,0,32,0,97,0,76,0,24,0,126,0,5,0,61,0,25,0,108,0,159,0,149,0,0,0,141,0,1,0,112,0,186,0,0,0,169,0,14,0,0,0,105,0,158,0,94,0,236,0,169,0,185,0,1,0,89,0,0,0,44,0,64,0,157,0,0,0,178,0,205,0,17,0,238,0,0,0,85,0,0,0,59,0,218,0,70,0,116,0,0,0,130,0,67,0,186,0,175,0,220,0,183,0,115,0,8,0,31,0,0,0,165,0,207,0,111,0,0,0,0,0,77,0,171,0,132,0,66,0,63,0,0,0,104,0,214,0,176,0,173,0,0,0,159,0,199,0,18,0,55,0,16,0,0,0,137,0,142,0,90,0,32,0,0,0,244,0,0,0,0,0,137,0,223,0,227,0,182,0,181,0,0,0,0,0,179,0,156,0,83,0,64,0,120,0,0,0,187,0,71,0,162,0,0,0,0,0,120,0,58,0,0,0,234,0,21,0,157,0,181,0,231,0,189,0,175,0,85,0,148,0,60,0,170,0,250,0,224,0,71,0,191,0,83,0,0,0,95,0,215,0,200,0,197,0,218,0,10,0,83,0,156,0,141,0,108,0,0,0,113,0,0,0,229,0,228,0,201,0,0,0,97,0,104,0,145,0,183,0,158,0,218,0,0,0,104,0,0,0,163,0,89,0,254,0,50,0,0,0,122,0,130,0,35,0,176,0,254,0,0,0,22,0,0,0,0,0,196,0,0,0,72,0,0,0,0,0,0,0,47,0,77,0,135,0,0,0,197,0,74,0,0,0,51,0,0,0,53,0,92,0,215,0,43,0,130,0,0,0,4,0,221,0,246,0,32,0,216,0,236,0,0,0,143,0,75,0,75,0,66,0,239,0,2,0,0,0,87,0,138,0,74,0,170,0,145,0,8,0,194,0,255,0,0,0,0,0,177,0,0,0,158,0,0,0,37,0,77,0,0,0,68,0,249,0,213,0,234,0,56,0,178,0,0,0,252,0,116,0,123,0,14,0,179,0,194,0);
signal scenario_full  : scenario_type := (50,31,98,31,27,31,188,31,188,30,188,29,188,28,52,31,107,31,252,31,252,30,120,31,78,31,141,31,186,31,38,31,134,31,106,31,222,31,222,30,194,31,82,31,123,31,62,31,111,31,122,31,74,31,2,31,116,31,116,30,66,31,153,31,194,31,251,31,243,31,181,31,181,30,181,29,230,31,230,30,42,31,42,30,55,31,85,31,85,30,64,31,64,30,47,31,77,31,153,31,118,31,190,31,222,31,196,31,226,31,59,31,59,30,125,31,5,31,90,31,239,31,90,31,188,31,43,31,69,31,165,31,122,31,49,31,138,31,138,30,138,29,149,31,190,31,177,31,181,31,13,31,13,30,13,29,40,31,149,31,111,31,131,31,254,31,254,30,48,31,223,31,214,31,188,31,22,31,163,31,242,31,174,31,179,31,85,31,168,31,87,31,182,31,176,31,159,31,173,31,250,31,250,30,76,31,208,31,90,31,90,30,162,31,101,31,101,30,166,31,161,31,208,31,208,30,193,31,122,31,166,31,84,31,79,31,232,31,232,30,107,31,107,30,107,29,62,31,62,30,201,31,125,31,125,30,247,31,75,31,60,31,77,31,160,31,28,31,116,31,116,30,60,31,250,31,134,31,105,31,8,31,8,30,215,31,237,31,219,31,248,31,48,31,230,31,101,31,151,31,151,30,6,31,255,31,255,30,10,31,214,31,213,31,83,31,159,31,157,31,163,31,163,30,88,31,111,31,14,31,4,31,4,30,130,31,126,31,76,31,143,31,214,31,214,30,164,31,72,31,72,30,72,29,191,31,191,30,191,29,191,28,173,31,108,31,142,31,158,31,95,31,95,30,95,29,16,31,198,31,194,31,194,30,72,31,72,30,53,31,195,31,87,31,177,31,240,31,225,31,111,31,111,30,111,29,234,31,153,31,178,31,180,31,180,30,57,31,166,31,126,31,199,31,199,30,162,31,81,31,179,31,179,30,20,31,250,31,250,30,177,31,177,30,105,31,105,30,90,31,241,31,93,31,52,31,221,31,250,31,78,31,249,31,249,30,251,31,79,31,241,31,241,30,3,31,226,31,141,31,251,31,136,31,110,31,110,30,32,31,97,31,76,31,24,31,126,31,5,31,61,31,25,31,108,31,159,31,149,31,149,30,141,31,1,31,112,31,186,31,186,30,169,31,14,31,14,30,105,31,158,31,94,31,236,31,169,31,185,31,1,31,89,31,89,30,44,31,64,31,157,31,157,30,178,31,205,31,17,31,238,31,238,30,85,31,85,30,59,31,218,31,70,31,116,31,116,30,130,31,67,31,186,31,175,31,220,31,183,31,115,31,8,31,31,31,31,30,165,31,207,31,111,31,111,30,111,29,77,31,171,31,132,31,66,31,63,31,63,30,104,31,214,31,176,31,173,31,173,30,159,31,199,31,18,31,55,31,16,31,16,30,137,31,142,31,90,31,32,31,32,30,244,31,244,30,244,29,137,31,223,31,227,31,182,31,181,31,181,30,181,29,179,31,156,31,83,31,64,31,120,31,120,30,187,31,71,31,162,31,162,30,162,29,120,31,58,31,58,30,234,31,21,31,157,31,181,31,231,31,189,31,175,31,85,31,148,31,60,31,170,31,250,31,224,31,71,31,191,31,83,31,83,30,95,31,215,31,200,31,197,31,218,31,10,31,83,31,156,31,141,31,108,31,108,30,113,31,113,30,229,31,228,31,201,31,201,30,97,31,104,31,145,31,183,31,158,31,218,31,218,30,104,31,104,30,163,31,89,31,254,31,50,31,50,30,122,31,130,31,35,31,176,31,254,31,254,30,22,31,22,30,22,29,196,31,196,30,72,31,72,30,72,29,72,28,47,31,77,31,135,31,135,30,197,31,74,31,74,30,51,31,51,30,53,31,92,31,215,31,43,31,130,31,130,30,4,31,221,31,246,31,32,31,216,31,236,31,236,30,143,31,75,31,75,31,66,31,239,31,2,31,2,30,87,31,138,31,74,31,170,31,145,31,8,31,194,31,255,31,255,30,255,29,177,31,177,30,158,31,158,30,37,31,77,31,77,30,68,31,249,31,213,31,234,31,56,31,178,31,178,30,252,31,116,31,123,31,14,31,179,31,194,31);

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
