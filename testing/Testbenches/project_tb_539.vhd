-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_539 is
end project_tb_539;

architecture project_tb_arch_539 of project_tb_539 is
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

constant SCENARIO_LENGTH : integer := 439;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (20,0,39,0,169,0,40,0,96,0,239,0,108,0,5,0,255,0,225,0,56,0,206,0,225,0,202,0,0,0,154,0,163,0,0,0,222,0,0,0,173,0,2,0,179,0,20,0,206,0,154,0,163,0,98,0,108,0,25,0,0,0,0,0,76,0,86,0,43,0,156,0,59,0,39,0,10,0,120,0,0,0,65,0,159,0,255,0,180,0,0,0,195,0,246,0,0,0,194,0,0,0,173,0,187,0,66,0,0,0,106,0,0,0,0,0,0,0,130,0,119,0,0,0,95,0,216,0,148,0,189,0,0,0,216,0,244,0,0,0,20,0,0,0,0,0,0,0,76,0,0,0,226,0,0,0,51,0,185,0,131,0,105,0,227,0,24,0,0,0,195,0,0,0,76,0,0,0,88,0,85,0,192,0,124,0,13,0,41,0,80,0,42,0,73,0,17,0,0,0,209,0,137,0,244,0,63,0,251,0,0,0,97,0,198,0,2,0,192,0,0,0,64,0,76,0,182,0,63,0,200,0,132,0,60,0,236,0,180,0,0,0,0,0,0,0,222,0,0,0,160,0,82,0,252,0,229,0,159,0,0,0,0,0,67,0,0,0,121,0,143,0,0,0,44,0,189,0,0,0,158,0,110,0,0,0,98,0,239,0,52,0,158,0,0,0,194,0,139,0,27,0,162,0,153,0,189,0,11,0,165,0,234,0,93,0,0,0,145,0,0,0,12,0,0,0,0,0,66,0,0,0,126,0,54,0,0,0,190,0,0,0,217,0,40,0,144,0,110,0,42,0,168,0,187,0,212,0,0,0,8,0,0,0,242,0,167,0,38,0,151,0,181,0,0,0,82,0,87,0,0,0,182,0,71,0,198,0,167,0,0,0,240,0,151,0,222,0,76,0,81,0,110,0,243,0,86,0,29,0,100,0,62,0,13,0,26,0,252,0,3,0,128,0,168,0,102,0,172,0,241,0,197,0,150,0,43,0,148,0,17,0,0,0,127,0,48,0,0,0,63,0,0,0,53,0,0,0,141,0,0,0,249,0,0,0,177,0,25,0,163,0,31,0,8,0,0,0,244,0,79,0,0,0,150,0,163,0,0,0,113,0,0,0,204,0,187,0,0,0,237,0,60,0,160,0,246,0,207,0,126,0,18,0,120,0,178,0,255,0,109,0,140,0,0,0,55,0,153,0,0,0,222,0,134,0,221,0,138,0,0,0,0,0,233,0,0,0,219,0,228,0,254,0,0,0,31,0,215,0,0,0,0,0,182,0,201,0,221,0,0,0,191,0,0,0,140,0,53,0,152,0,39,0,3,0,0,0,152,0,185,0,0,0,204,0,165,0,112,0,189,0,39,0,229,0,0,0,0,0,101,0,116,0,0,0,78,0,155,0,103,0,115,0,0,0,0,0,222,0,253,0,136,0,69,0,39,0,113,0,59,0,223,0,210,0,15,0,0,0,229,0,195,0,16,0,233,0,164,0,253,0,164,0,190,0,162,0,91,0,98,0,238,0,166,0,0,0,232,0,8,0,33,0,193,0,0,0,225,0,0,0,183,0,234,0,182,0,40,0,35,0,221,0,248,0,246,0,36,0,159,0,112,0,174,0,0,0,144,0,217,0,201,0,80,0,1,0,123,0,21,0,136,0,56,0,59,0,135,0,92,0,162,0,140,0,121,0,0,0,132,0,127,0,25,0,146,0,226,0,177,0,53,0,40,0,217,0,191,0,0,0,141,0,12,0,226,0,0,0,0,0,0,0,20,0,171,0,0,0,107,0,0,0,59,0,41,0,64,0,245,0,48,0,0,0,119,0,86,0,43,0,0,0,225,0,44,0,0,0,0,0,211,0,25,0,242,0,0,0,255,0,224,0,53,0,0,0,33,0,62,0,75,0,119,0,36,0,12,0,113,0,144,0,165,0,87,0,76,0,85,0,129,0,150,0,81,0,0,0,0,0,148,0,130,0,0,0);
signal scenario_full  : scenario_type := (20,31,39,31,169,31,40,31,96,31,239,31,108,31,5,31,255,31,225,31,56,31,206,31,225,31,202,31,202,30,154,31,163,31,163,30,222,31,222,30,173,31,2,31,179,31,20,31,206,31,154,31,163,31,98,31,108,31,25,31,25,30,25,29,76,31,86,31,43,31,156,31,59,31,39,31,10,31,120,31,120,30,65,31,159,31,255,31,180,31,180,30,195,31,246,31,246,30,194,31,194,30,173,31,187,31,66,31,66,30,106,31,106,30,106,29,106,28,130,31,119,31,119,30,95,31,216,31,148,31,189,31,189,30,216,31,244,31,244,30,20,31,20,30,20,29,20,28,76,31,76,30,226,31,226,30,51,31,185,31,131,31,105,31,227,31,24,31,24,30,195,31,195,30,76,31,76,30,88,31,85,31,192,31,124,31,13,31,41,31,80,31,42,31,73,31,17,31,17,30,209,31,137,31,244,31,63,31,251,31,251,30,97,31,198,31,2,31,192,31,192,30,64,31,76,31,182,31,63,31,200,31,132,31,60,31,236,31,180,31,180,30,180,29,180,28,222,31,222,30,160,31,82,31,252,31,229,31,159,31,159,30,159,29,67,31,67,30,121,31,143,31,143,30,44,31,189,31,189,30,158,31,110,31,110,30,98,31,239,31,52,31,158,31,158,30,194,31,139,31,27,31,162,31,153,31,189,31,11,31,165,31,234,31,93,31,93,30,145,31,145,30,12,31,12,30,12,29,66,31,66,30,126,31,54,31,54,30,190,31,190,30,217,31,40,31,144,31,110,31,42,31,168,31,187,31,212,31,212,30,8,31,8,30,242,31,167,31,38,31,151,31,181,31,181,30,82,31,87,31,87,30,182,31,71,31,198,31,167,31,167,30,240,31,151,31,222,31,76,31,81,31,110,31,243,31,86,31,29,31,100,31,62,31,13,31,26,31,252,31,3,31,128,31,168,31,102,31,172,31,241,31,197,31,150,31,43,31,148,31,17,31,17,30,127,31,48,31,48,30,63,31,63,30,53,31,53,30,141,31,141,30,249,31,249,30,177,31,25,31,163,31,31,31,8,31,8,30,244,31,79,31,79,30,150,31,163,31,163,30,113,31,113,30,204,31,187,31,187,30,237,31,60,31,160,31,246,31,207,31,126,31,18,31,120,31,178,31,255,31,109,31,140,31,140,30,55,31,153,31,153,30,222,31,134,31,221,31,138,31,138,30,138,29,233,31,233,30,219,31,228,31,254,31,254,30,31,31,215,31,215,30,215,29,182,31,201,31,221,31,221,30,191,31,191,30,140,31,53,31,152,31,39,31,3,31,3,30,152,31,185,31,185,30,204,31,165,31,112,31,189,31,39,31,229,31,229,30,229,29,101,31,116,31,116,30,78,31,155,31,103,31,115,31,115,30,115,29,222,31,253,31,136,31,69,31,39,31,113,31,59,31,223,31,210,31,15,31,15,30,229,31,195,31,16,31,233,31,164,31,253,31,164,31,190,31,162,31,91,31,98,31,238,31,166,31,166,30,232,31,8,31,33,31,193,31,193,30,225,31,225,30,183,31,234,31,182,31,40,31,35,31,221,31,248,31,246,31,36,31,159,31,112,31,174,31,174,30,144,31,217,31,201,31,80,31,1,31,123,31,21,31,136,31,56,31,59,31,135,31,92,31,162,31,140,31,121,31,121,30,132,31,127,31,25,31,146,31,226,31,177,31,53,31,40,31,217,31,191,31,191,30,141,31,12,31,226,31,226,30,226,29,226,28,20,31,171,31,171,30,107,31,107,30,59,31,41,31,64,31,245,31,48,31,48,30,119,31,86,31,43,31,43,30,225,31,44,31,44,30,44,29,211,31,25,31,242,31,242,30,255,31,224,31,53,31,53,30,33,31,62,31,75,31,119,31,36,31,12,31,113,31,144,31,165,31,87,31,76,31,85,31,129,31,150,31,81,31,81,30,81,29,148,31,130,31,130,30);

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
